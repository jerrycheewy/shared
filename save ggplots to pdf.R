# Save multiple ggplots into a multi-page pdf document

library(ggplot2)
library(dplyr)
library(tidyr)

# Sample where we're 'looping' over a variable `trans` (transmission) to create multiple heatmaps
my_heatmap <- ggplot(mpg, aes(x = manufacturer, y = class)) + geom_tile(aes(fill = hwy)) + facet_wrap(~trans)

# Create version where we code the loop so that it can be printed into separate pdf pages

# step 0 (optional): Fill in the missing pairs if you want your heatmap to look nice
my_mpg <- mpg %>% complete(manufacturer, class, trans, fill = list(hwy = NA))

# Step 1: Create a list of plots
plot_list <- list()
for (i in 1:n_distinct(mpg$trans)){
  trans_list <- unique(mpg$trans)
  plot_list[[i]] <- ggplot(my_mpg %>% 
                             filter(trans == trans_list[i]), # Get only the loop you want
                           aes(x = manufacturer, y = class)) +  # Set the X and Y dimensions
    geom_tile(aes(fill = hwy), colour = "grey") + # Fill the squares with the values desired
    scale_fill_gradient2(high = "red", mid = "white", low = "green", na.value = "white") +  #Tweak custom colours and fill empty squares
    coord_fixed() + # Keep the heatmap squares a standardised size
    theme(axis.text.x = element_text(angle = 90), legend.position = "bottom") # Pivot x-axis words to prevent overlapping
}

# Step 2: Print to pdf
pdf(paste0("heatmaps ", Sys.Date(), ".pdf"))
for (i in 1:length(plot_list)) {
  print(plot_list[[i]])
}
dev.off()