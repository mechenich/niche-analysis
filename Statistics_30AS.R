library(raster)
library(rgdal)

z <- '/home/ad/home/m/mechenic/'

arguments <- commandArgs(trailingOnly = TRUE)
family <- arguments[1]
sid <- as.integer(arguments[2])
bio <- as.integer(arguments[3])

bioraster <- raster(paste(z, 'Projects/Shared Datasets/WorldClim/BIO_30S/wc2.0_bio_30s_',
                          sprintf('%02i', bio), '.tif', sep = ''))

sidshape <- readOGR(paste(z, 'Ecosphere/Datasets/IUCNRL_V201901/', family, '/IUCNRL_V201901_SID',
                          sprintf('%09i', sid), '.shp', sep = ''))

sidraster <- crop(bioraster, sidshape)
sidraster <- mask(sidraster, sidshape)

values <- rasterToPoints(sidraster)[, 3]

quantiles <- sprintf('%0.6f', quantile(values, probs = seq(from = 0, to = 1, by = 0.1)))

write.table(c(sprintf('%09i', sid), sprintf('%02i', bio), quantiles, sprintf('%0.6f', mean(values))),
            file = paste(z, 'Projects/Mammals/SID', sprintf('%09i', sid), '_BIO', sprintf('%02i', bio),
                         '_Statistics_30AS.txt', sep = ''),
            quote = FALSE,
            sep = '\t',
            row.names = FALSE,
            col.names = FALSE)