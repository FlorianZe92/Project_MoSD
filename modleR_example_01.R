#set your working directory to a folder called modleR_test, where you want to save the provenance data
#setwd(.../modleR_test)

rdt2repr::collectprov()
#after this command, the consol will ask you for the folder, where you want to save the provenance data
#choose . for the current directory
library(modleR)
library(rJava)

str(example_occs)

species <- names(example_occs)
species

#In speciesID you can choose the species you want to analyze
#Choose: 
#1 for Abarema langsdorffii
#2 Eugenia florida
#3 Leandra carassana
#4 Ouratea semiserrata
speciesID<-1

library(sp)
par(mfrow = c(2, 2), mar = c(2, 2, 3, 1))
for (i in 1:length(example_occs)) {
  plot(!is.na(example_vars[[1]]),
       legend = FALSE,
       main = species[i],
       col = c("white", "#00A08A"))
  points(lat ~ lon, data = example_occs[[i]], pch = 19)
}
par(mfrow = c(1, 1))

occs <- example_occs[[1]]

args(setup_sdmdata)

test_folder <- "~/modleR_test"
sdmdata_1sp <- setup_sdmdata(species_name = species[speciesID],
                             occurrences = occs,
                             predictors = example_vars,
                             models_dir = test_folder,
                             partition_type = "crossvalidation",
                             cv_partitions = 5,
                             cv_n = 1,
                             seed = 512,
                             buffer_type = "mean",
                             png_sdmdata = TRUE,
                             n_back = 500,
                             clean_dupl = TRUE,
                             clean_uni = TRUE,
                             clean_nas = TRUE,
                             geo_filt = FALSE,
                             geo_filt_dist = 10,
                             select_variables = TRUE,
                             sample_proportion = 0.5,
                             cutoff = 0.7)

sp_maxent <- do_any(species_name = species[speciesID],
                    algorithm = "maxent",
                    predictors = example_vars,
                    models_dir = test_folder,
                    png_partitions = TRUE,
                    write_bin_cut = FALSE,
                    equalize = TRUE,
                    write_rda = TRUE)


sp_maxent

many <- do_many(species_name = species[speciesID],
                predictors = example_vars,
                models_dir = test_folder,
                png_partitions = TRUE,
                write_bin_cut = FALSE,
                write_rda = TRUE,
                bioclim = TRUE,
                domain = FALSE,
                glm = TRUE,
                svmk = TRUE,
                svme = TRUE,
                maxent = TRUE,
                maxnet = TRUE,
                rf = TRUE,
                mahal = FALSE,
                brt = TRUE,
                equalize = TRUE)

final_model(species_name = species[speciesID],
            algorithms = NULL, #if null it will take all the algorithms in disk
            models_dir = test_folder,
            which_models = c("raw_mean",
                             "bin_mean",
                             "bin_consensus"),
            consensus_level = 0.5,
            uncertainty = TRUE,
            overwrite = TRUE)

ens <- ensemble_model(species_name = species[speciesID],
                      occurrences = occs,
                      performance_metric = "pROC",
                      which_ensemble = c("average",
                                         "best",
                                         "frequency",
                                         "weighted_average",
                                         "median",
                                         "pca",
                                         "consensus"),
                      consensus_level = 0.5,
                      which_final = "raw_mean",
                      models_dir = test_folder,
                      overwrite = TRUE)


plot(ens)
rdt2repr::endprov()
