# web of science meta-analysis

# ---- 1. load libraries ----
# install.packages("devtools")  # if required
# devtools::install_github("juba/rwos")
library(rwos)
library(tidyverse)
library(here)
library(beepr)

# define paths 
# tabular_raw_data_path <- here("data", "tabular", "wos_raw_data")
tabular_raw_data_path <- "/Users/sheila/Documents/phd/pao_lit_review/pao-review-analysis/raw_data/" # (use hardcoding for now)
# tabular_raw_data_path <- "/Users/sheila/Dropbox/aaaaa_transfers/full_submission_mar2020/raw_data/" # (use hardcoding for now)


# rwos docs
# https://github.com/juba/rwos

# lite API only (limited metadata returned)
# options: "SCI", "IC", "ISTP", "ISSHP"
# more info on editions here: http://help.incites.clarivate.com/wosWebServicesLite/dbEditionsOptionsGroup/databaseEditionsWos.html
# USFS only authorized for "SCI" (Science Citation Index Expanded)
# http://help.incites.clarivate.com/inCites2Live/dataAndSubscriptionNotificationsGroup/dataAndSubsNotice.html


# ---- 2. initiate wos session ----
# get session identifier
sid <- wos_authenticate()


# ---- 4. "phosphate" search ----
# as of 20200302 at 10am

# search for articles
phos_result <- wos_search(sid, "TS='phosphorus' AND DT = Article", editions = c("SCI")) # 183683 results found
phos_wwtp_result <- wos_search(sid, "TS='phosphorus' AND TS='wastewater' AND DT = Article", editions = c("SCI")) # 8427
phos_soil_result <- wos_search(sid, "TS='phosphorus' AND TS='soil' AND DT = Article", editions = c("SCI")) # 39481
phos_sed_result <- wos_search(sid, "TS='phosphorus' AND TS='sediment' AND DT = Article", editions = c("SCI")) # 12570
phos_lake_result <- wos_search(sid, "TS='phosphorus' AND TS='lake' AND DT = Article", editions = c("SCI")) # 13394
phos_stream_result <- wos_search(sid, "TS='phosphorus' AND TS='stream' AND DT = Article", editions = c("SCI")) # 5571
phos_river_result <- wos_search(sid, "TS='phosphorus' AND TS='river' AND DT = Article", editions = c("SCI")) # 10166
phos_fw_result <- wos_search(sid, "TS='phosphorus' AND (TS='freshwater' OR TS='fresh water') AND DT = Article", editions = c("SCI")) # 6901
phos_marine_result <- wos_search(sid, "TS='phosphorus' AND TS='marine' AND DT = Article", editions = c("SCI")) # 4943
phos_ocean_result <- wos_search(sid, "TS='phosphorus' AND TS='ocean' AND DT = Article", editions = c("SCI")) # 2416
phos_sw_result <- wos_search(sid, "TS='phosphorus' AND (TS='salt water' OR TS='saltwater') AND DT = Article", editions = c("SCI")) # 1976
phos_ag_result <- wos_search(sid, "TS='phosphorus' AND TS='agriculture' AND DT = Article", editions = c("SCI")) # 4420

# retrieve pub info
# phos_pubs_raw <- wos_retrieve(phos_result, count = 200)
# can't only download 100k at a time and can't find a way to parse phos_results so skip retrieval of "all" pubs for now
# phos_pubs_raw_1to100k <- wos_retrieve(phos_result, first = 1, count = 100000) %>% mutate(environment = "all", category = "all") # this works
# phos_pubs_raw_100kto200k <- wos_retrieve(phos_result, first = 100001, count = 200000) %>% mutate(environment = "all", category = "all") # this doesn't work
# phos_pubs_raw_200kto300k <- wos_retrieve(phos_result, first = 200001, count = 300000) %>% mutate(environment = "all", category = "all") # this doesn't work
# phos_pubs_raw_300ktoend <- wos_retrieve(phos_result, first = 300001, count = 346612) %>% mutate(environment = "all", category = "all") # this doesn't work
# phos_pubs_raw <- bind_rows(phos_pubs_raw_1to100k, phos_pubs_raw_100kto200k, phos_pubs_raw_200kto300k, phos_pubs_raw_300ktoend) this doesn't work
phos_wwtp_pubs_raw <- wos_retrieve_all(phos_wwtp_result) %>% mutate(environment = "wwtp", category = "wwtp")
phos_soil_pubs_raw <- wos_retrieve_all(phos_soil_result) %>% mutate(environment = "soil", category = "terrestrial")
phos_sed_pubs_raw <- wos_retrieve_all(phos_sed_result) %>% mutate(environment = "sediment", category = "terrestrial")
phos_lake_pubs_raw <- wos_retrieve_all(phos_lake_result) %>% mutate(environment = "lake", category = "freshwater")
phos_stream_pubs_raw <- wos_retrieve_all(phos_stream_result) %>% mutate(environment = "stream", category = "freshwater")
phos_river_pubs_raw <- wos_retrieve_all(phos_river_result) %>% mutate(environment = "river", category = "freshwater")
phos_fw_pubs_raw <- wos_retrieve_all(phos_fw_result) %>% mutate(environment = "freshwater", category = "freshwater")
phos_marine_pubs_raw <- wos_retrieve_all(phos_marine_result) %>% mutate(environment = "marine", category = "marine")
phos_ocean_pubs_raw <- wos_retrieve_all(phos_ocean_result) %>% mutate(environment = "ocean", category = "marine")
phos_sw_pubs_raw <- wos_retrieve_all(phos_sw_result) %>% mutate(environment = "saltwater", category = "marine")
phos_ag_pubs_raw <- wos_retrieve_all(phos_ag_result) %>% mutate(environment = "agriculture", category = "agriculture")
beepr::beep(sound = 5)

# export raw data for future reading in
# write_csv(x = phos_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_pubs_raw.csv")) # see note above
write_csv(x = phos_wwtp_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_wwtp_pubs_raw.csv"))
write_csv(x = phos_soil_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_soil_pubs_raw.csv"))
write_csv(x = phos_sed_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_sed_pubs_raw.csv"))
write_csv(x = phos_lake_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_lake_pubs_raw.csv"))
write_csv(x = phos_stream_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_stream_pubs_raw.csv"))
write_csv(x = phos_river_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_river_pubs_raw.csv"))
write_csv(x = phos_fw_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_fw_pubs_raw.csv"))
write_csv(x = phos_marine_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_marine_pubs_raw.csv"))
write_csv(x = phos_ocean_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_ocean_pubs_raw.csv"))
write_csv(x = phos_sw_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_sw_pubs_raw.csv"))
write_csv(x = phos_ag_pubs_raw,  path = paste0(tabular_raw_data_path, "phos_ag_pubs_raw.csv"))

# bind rows
phos_all_searches_pubs_raw <- bind_rows(phos_wwtp_pubs_raw,
                                        phos_soil_pubs_raw, phos_sed_pubs_raw,
                                        phos_lake_pubs_raw, phos_stream_pubs_raw,
                                        phos_river_pubs_raw, phos_fw_pubs_raw,
                                        phos_marine_pubs_raw, phos_ocean_pubs_raw,
                                        phos_sw_pubs_raw, phos_ag_pubs_raw)
# phos_all_searches_pubs_raw <- bind_rows(phos_pubs_raw, phos_wwtp_pubs_raw,
#                                         phos_soil_pubs_raw, phos_sed_pubs_raw,
#                                         phos_lake_pubs_raw, phos_stream_pubs_raw,
#                                         phos_river_pubs_raw, phos_fw_pubs_raw,
#                                         phos_marine_pubs_raw, phos_ocean_pubs_raw,
#                                         phos_sw_pubs_raw, phos_ag_pubs_raw) # see note above

# export full dataset
write_csv(x = phos_all_searches_pubs_raw, path = paste0(tabular_raw_data_path, "phos_all_searches_pubs_raw.csv"))


# ---- 5. "microbiology" search ----
# as of 20200302 at 10am

# search for articles
microbio_result <- wos_search(sid, "TS='microbiology' AND DT = Article", editions = c("SCI")) # 25359 results found
microbio_wwtp_result <- wos_search(sid, "TS='microbiology' AND TS='wastewater' AND DT = Article", editions = c("SCI")) # 277
microbio_soil_result <- wos_search(sid, "TS='microbiology' AND TS='soil' AND DT = Article", editions = c("SCI")) # 1138
microbio_sed_result <- wos_search(sid, "TS='microbiology' AND TS='sediment' AND DT = Article", editions = c("SCI")) # 443
microbio_lake_result <- wos_search(sid, "TS='microbiology' AND TS='lake' AND DT = Article", editions = c("SCI")) # 188
microbio_stream_result <- wos_search(sid, "TS='microbiology' AND TS='stream' AND DT = Article", editions = c("SCI")) # 518
microbio_river_result <- wos_search(sid, "TS='microbiology' AND TS='river' AND DT = Article", editions = c("SCI")) # 186
microbio_fw_result <- wos_search(sid, "TS='microbiology' AND (TS='freshwater' OR TS='fresh water') AND DT = Article", editions = c("SCI")) # 264
microbio_marine_result <- wos_search(sid, "TS='microbiology' AND TS='marine' AND DT = Article", editions = c("SCI")) # 485
microbio_ocean_result <- wos_search(sid, "TS='microbiology' AND TS='ocean' AND DT = Article", editions = c("SCI")) # 167
microbio_sw_result <- wos_search(sid, "TS='microbiology' AND (TS='salt water' OR TS='saltwater') AND DT = Article", editions = c("SCI")) # 103
microbio_ag_result <- wos_search(sid, "TS='microbiology' AND TS='agriculture' AND DT = Article", editions = c("SCI")) # 221

# retrieve pub info
# microbio_pubs_raw <- wos_retrieve(microbio_result, count = 200)
microbio_pubs_raw <- wos_retrieve_all(microbio_result) %>% mutate(environment = "all", category = "all") # will pull all records
microbio_wwtp_pubs_raw <- wos_retrieve_all(microbio_wwtp_result) %>% mutate(environment = "wwtp", category = "wwtp")
microbio_soil_pubs_raw <- wos_retrieve_all(microbio_soil_result) %>% mutate(environment = "soil", category = "terrestrial")
microbio_sed_pubs_raw <- wos_retrieve_all(microbio_sed_result) %>% mutate(environment = "sediment", category = "terrestrial")
microbio_lake_pubs_raw <- wos_retrieve_all(microbio_lake_result) %>% mutate(environment = "lake", category = "freshwater")
microbio_stream_pubs_raw <- wos_retrieve_all(microbio_stream_result) %>% mutate(environment = "stream", category = "freshwater")
microbio_river_pubs_raw <- wos_retrieve_all(microbio_river_result) %>% mutate(environment = "river", category = "freshwater")
microbio_fw_pubs_raw <- wos_retrieve_all(microbio_fw_result) %>% mutate(environment = "freshwater", category = "freshwater")
microbio_marine_pubs_raw <- wos_retrieve_all(microbio_marine_result) %>% mutate(environment = "marine", category = "marine")
microbio_ocean_pubs_raw <- wos_retrieve_all(microbio_ocean_result) %>% mutate(environment = "ocean", category = "marine")
microbio_sw_pubs_raw <- wos_retrieve_all(microbio_sw_result) %>% mutate(environment = "saltwater", category = "marine")
microbio_ag_pubs_raw <- wos_retrieve_all(microbio_ag_result) %>% mutate(environment = "agriculture", category = "agriculture")
beepr::beep(sound = 5)

# export raw data for future reading in
write_csv(x = microbio_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_pubs_raw.csv"))
write_csv(x = microbio_wwtp_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_wwtp_pubs_raw.csv"))
write_csv(x = microbio_soil_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_soil_pubs_raw.csv"))
write_csv(x = microbio_sed_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_sed_pubs_raw.csv"))
write_csv(x = microbio_lake_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_lake_pubs_raw.csv"))
write_csv(x = microbio_stream_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_stream_pubs_raw.csv"))
write_csv(x = microbio_river_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_river_pubs_raw.csv"))
write_csv(x = microbio_fw_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_fw_pubs_raw.csv"))
write_csv(x = microbio_marine_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_marine_pubs_raw.csv"))
write_csv(x = microbio_ocean_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_ocean_pubs_raw.csv"))
write_csv(x = microbio_sw_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_sw_pubs_raw.csv"))
write_csv(x = microbio_ag_pubs_raw,  path = paste0(tabular_raw_data_path, "microbio_ag_pubs_raw.csv"))

# bind rows
microbio_all_searches_pubs_raw <- bind_rows(microbio_pubs_raw, microbio_wwtp_pubs_raw,
                                            microbio_soil_pubs_raw, microbio_sed_pubs_raw,
                                            microbio_lake_pubs_raw, microbio_stream_pubs_raw,
                                            microbio_river_pubs_raw, microbio_fw_pubs_raw,
                                            microbio_marine_pubs_raw, microbio_ocean_pubs_raw,
                                            microbio_sw_pubs_raw, microbio_ag_pubs_raw)

# export full dataset
write_csv(x = microbio_all_searches_pubs_raw, path = paste0(tabular_raw_data_path, "microbio_all_searches_pubs_raw.csv"))


# ---- 6. "polyphosphate" search ----
# as of 20200302 at 10am

# search for articles
polyp_result <- wos_search(sid, "TS='polyphosphate' AND DT = Article", editions = c("SCI")) # 9217 results found
polyp_wwtp_result <- wos_search(sid, "TS='polyphosphate' AND TS='wastewater' AND DT = Article", editions = c("SCI")) # 542
polyp_soil_result <- wos_search(sid, "TS='polyphosphate' AND TS='soil' AND DT = Article", editions = c("SCI")) # 288
polyp_sed_result <- wos_search(sid, "TS='polyphosphate' AND TS='sediment' AND DT = Article", editions = c("SCI")) # 169
polyp_lake_result <- wos_search(sid, "TS='polyphosphate' AND TS='lake' AND DT = Article", editions = c("SCI"))# 159
polyp_stream_result <- wos_search(sid, "TS='polyphosphate' AND TS='stream' AND DT = Article", editions = c("SCI")) # 62
polyp_river_result <- wos_search(sid, "TS='polyphosphate' AND TS='river' AND DT = Article", editions = c("SCI")) # 44
polyp_fw_result <- wos_search(sid, "TS='polyphosphate' AND (TS='freshwater' OR TS='fresh water') AND DT = Article", editions = c("SCI")) # 102
polyp_marine_result <- wos_search(sid, "TS='polyphosphate' AND TS='marine' AND DT = Article", editions = c("SCI")) # 138
polyp_ocean_result <- wos_search(sid, "TS='polyphosphate' AND TS='ocean' AND DT = Article", editions = c("SCI")) # 34
polyp_sw_result <- wos_search(sid, "TS='polyphosphate' AND (TS='salt water' OR TS='saltwater') AND DT = Article", editions = c("SCI")) # 96
polyp_ag_result <- wos_search(sid, "TS='polyphosphate' AND TS='agriculture' AND DT = Article", editions = c("SCI")) # 14

# retrieve pub info
# polyp_pubs_raw <- wos_retrieve(polyp_result, count = 200)
polyp_pubs_raw <- wos_retrieve_all(polyp_result) %>% mutate(environment = "all", category = "all") # will pull all records
polyp_wwtp_pubs_raw <- wos_retrieve_all(polyp_wwtp_result) %>% mutate(environment = "wwtp", category = "wwtp")
polyp_soil_pubs_raw <- wos_retrieve_all(polyp_soil_result) %>% mutate(environment = "soil", category = "terrestrial")
polyp_sed_pubs_raw <- wos_retrieve_all(polyp_sed_result) %>% mutate(environment = "sediment", category = "terrestrial")
polyp_lake_pubs_raw <- wos_retrieve_all(polyp_lake_result) %>% mutate(environment = "lake", category = "freshwater")
polyp_stream_pubs_raw <- wos_retrieve_all(polyp_stream_result) %>% mutate(environment = "stream", category = "freshwater")
polyp_river_pubs_raw <- wos_retrieve_all(polyp_river_result) %>% mutate(environment = "river", category = "freshwater")
polyp_fw_pubs_raw <- wos_retrieve_all(polyp_fw_result) %>% mutate(environment = "freshwater", category = "freshwater")
polyp_marine_pubs_raw <- wos_retrieve_all(polyp_marine_result) %>% mutate(environment = "marine", category = "marine")
polyp_ocean_pubs_raw <- wos_retrieve_all(polyp_ocean_result) %>% mutate(environment = "ocean", category = "marine")
polyp_sw_pubs_raw <- wos_retrieve_all(polyp_sw_result) %>% mutate(environment = "saltwater", category = "marine")
polyp_ag_pubs_raw <- wos_retrieve_all(polyp_ag_result) %>% mutate(environment = "agriculture", category = "agriculture")
beepr::beep(sound = 5)

# export raw data for future reading in
write_csv(x = polyp_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_pubs_raw.csv"))
write_csv(x = polyp_wwtp_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_wwtp_pubs_raw.csv"))
write_csv(x = polyp_soil_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_soil_pubs_raw.csv"))
write_csv(x = polyp_sed_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_sed_pubs_raw.csv"))
write_csv(x = polyp_lake_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_lake_pubs_raw.csv"))
write_csv(x = polyp_stream_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_stream_pubs_raw.csv"))
write_csv(x = polyp_river_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_river_pubs_raw.csv"))
write_csv(x = polyp_fw_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_fw_pubs_raw.csv"))
write_csv(x = polyp_marine_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_marine_pubs_raw.csv"))
write_csv(x = polyp_ocean_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_ocean_pubs_raw.csv"))
write_csv(x = polyp_sw_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_sw_pubs_raw.csv"))
write_csv(x = polyp_ag_pubs_raw,  path = paste0(tabular_raw_data_path, "polyp_ag_pubs_raw.csv"))

# bind rows
polyp_all_searches_pubs_raw <- bind_rows(polyp_pubs_raw, polyp_wwtp_pubs_raw,
                                         polyp_soil_pubs_raw, polyp_sed_pubs_raw,
                                         polyp_lake_pubs_raw, polyp_stream_pubs_raw,
                                         polyp_river_pubs_raw, polyp_fw_pubs_raw,
                                         polyp_marine_pubs_raw, polyp_ocean_pubs_raw, 
                                         polyp_sw_pubs_raw, polyp_ag_pubs_raw)

# export full dataset
write_csv(x = polyp_all_searches_pubs_raw, path = paste0(tabular_raw_data_path, "polyp_all_searches_pubs_raw.csv"))


# ---- 7. "polyphosphate accumulating organisms" search ----
# as of 20200302 at 10am

# search for articles
pao_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND DT = Article", editions = c("SCI")) # 796 results found
pao_wwtp_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='wastewater' AND DT = Article", editions = c("SCI")) # 367
pao_soil_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='soil' AND DT = Article", editions = c("SCI")) # 18
pao_sed_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='sediment' AND DT = Article", editions = c("SCI")) # 11
pao_lake_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='lake' AND DT = Article", editions = c("SCI"))# 11
pao_stream_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='stream' AND DT = Article", editions = c("SCI")) # 25
pao_river_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='river' AND DT = Article", editions = c("SCI")) # 3
pao_fw_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND (TS='freshwater' OR TS='fresh water') AND DT = Article", editions = c("SCI")) # 13
pao_marine_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='marine' AND DT = Article", editions = c("SCI")) # 6
pao_ocean_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='ocean' AND DT = Article", editions = c("SCI")) # 2
pao_sw_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND (TS='salt water' OR TS='saltwater') AND DT = Article", editions = c("SCI")) # 7
pao_ag_result <- wos_search(sid, "TS='polyphosphate accumulating organisms' AND TS='agriculture' AND DT = Article", editions = c("SCI")) # 1

# retrieve pub info
# pao_pubs_raw <- wos_retrieve(pao_result, count = 200)
pao_pubs_raw <- wos_retrieve_all(pao_result) %>% mutate(environment = "all", category = "all") # will pull all records
pao_wwtp_pubs_raw <- wos_retrieve_all(pao_wwtp_result) %>% mutate(environment = "wwtp", category = "wwtp")
pao_soil_pubs_raw <- wos_retrieve_all(pao_soil_result) %>% mutate(environment = "soil", category = "terrestrial")
pao_sed_pubs_raw <- wos_retrieve_all(pao_sed_result) %>% mutate(environment = "sediment", category = "terrestrial")
pao_lake_pubs_raw <- wos_retrieve_all(pao_lake_result) %>% mutate(environment = "lake", category = "freshwater")
pao_stream_pubs_raw <- wos_retrieve_all(pao_stream_result) %>% mutate(environment = "stream", category = "freshwater")
pao_river_pubs_raw <- wos_retrieve_all(pao_river_result) %>% mutate(environment = "river", category = "freshwater")
pao_fw_pubs_raw <- wos_retrieve_all(pao_fw_result) %>% mutate(environment = "freshwater", category = "freshwater")
pao_marine_pubs_raw <- wos_retrieve_all(pao_marine_result) %>% mutate(environment = "marine", category = "marine")
pao_ocean_pubs_raw <- wos_retrieve_all(pao_ocean_result) %>% mutate(environment = "ocean", category = "marine")
pao_sw_pubs_raw <- wos_retrieve_all(pao_sw_result) %>% mutate(environment = "saltwater", category = "marine")
pao_ag_pubs_raw <- wos_retrieve_all(pao_ag_result) %>% mutate(environment = "agriculture", category = "agriculture")
beepr::beep(sound = 5)

# export raw data for future reading in
write_csv(x = pao_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_pubs_raw.csv"))
write_csv(x = pao_wwtp_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_wwtp_pubs_raw.csv"))
write_csv(x = pao_soil_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_soil_pubs_raw.csv"))
write_csv(x = pao_sed_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_sed_pubs_raw.csv"))
write_csv(x = pao_lake_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_lake_pubs_raw.csv"))
write_csv(x = pao_stream_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_stream_pubs_raw.csv"))
write_csv(x = pao_river_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_river_pubs_raw.csv"))
write_csv(x = pao_fw_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_fw_pubs_raw.csv"))
write_csv(x = pao_marine_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_marine_pubs_raw.csv"))
write_csv(x = pao_ocean_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_ocean_pubs_raw.csv"))
write_csv(x = pao_sw_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_sw_pubs_raw.csv"))
write_csv(x = pao_ag_pubs_raw,  path = paste0(tabular_raw_data_path, "pao_ag_pubs_raw.csv"))

# bind rows
pao_all_searches_pubs_raw <- bind_rows(pao_pubs_raw, pao_wwtp_pubs_raw,
                                       pao_soil_pubs_raw, pao_sed_pubs_raw,
                                       pao_lake_pubs_raw, pao_stream_pubs_raw,
                                       pao_river_pubs_raw, pao_fw_pubs_raw,
                                       pao_marine_pubs_raw, pao_ocean_pubs_raw, 
                                       pao_sw_pubs_raw, pao_ag_pubs_raw)

# export full dataset
write_csv(x = pao_all_searches_pubs_raw, path = paste0(tabular_raw_data_path, "pao_all_searches_pubs_raw.csv"))

