
<!-- README.md is generated from README.Rmd. Please edit that file -->

# 1 SpatioTemporalCont

<!-- badges: start -->
<!-- badges: end -->

The ‘SpatioTemporalCont’ R package provides a robust suite of tools for
evaluating both the spatial and temporal continuity of land use cover.
Tailored for the analysis of geospatial datasets, this package enables
users to quantify the spatial arrangement of habitats within a specified
radius and track temporal changes in land use over a given time series.

## 1.1 Spatial Continuity Analysis

For spatial continuity analysis, the package employs a circular moving
window approach, allowing users to define the radius of interest, such
as 2000 meters. The tool calculates the proportion of each habitat
within the specified radius, offering insights into the spatial
distribution of land use cover. A comprehensive wrap-up function is
available, simplifying the process and providing a holistic overview of
spatial continuity functionalities.

## 1.2 Temporal Continuity Analysis

‘SpatioTemporalCont’ also facilitates the analysis of temporal
continuity by evaluating how long a pixel has remained in the same land
use category over a temporal sequence. This feature is particularly
valuable for understanding the stability and persistence of land use
patterns over time.

## 1.3 User-Friendly Functionality

The package is designed with user-friendliness in mind, seamlessly
integrating into R workflows. It builds upon existing geospatial
analysis capabilities, offering a streamlined workflow for spatial and
temporal continuity assessments. Users can leverage the package to gain
valuable insights into the dynamics of land use cover, enabling informed
decision-making based on both spatial and temporal perspectives.

## 1.4 Installation

To install the development version of ‘SpatioTemporalCont’ from
[GitHub](https://github.com/), use the following code:

``` r
# install.packages("devtools")
devtools::install_github("derek-corcoran-barrios/SpatioTemporalCont")
```

# 2 Example of use of the different functions

## 2.1 Spatial continuity

Even though there is a wrap up function that can do most of the
functionalities of spatial continuity we will go step by step to show
how they interact together, first we will show a very upscaled fragment
of the basemap 4 landuse map of Denmark, for that we will use the
included dataset `dry_wet_nature` which is a wrapped dataset

``` r
library(SpatioTemporalCont)
library(terra)
#> terra 1.7.69
## basic example code
data("dry_wet_nature")
nature <- terra::unwrap(dry_wet_nature)
```

We can see the dry nature type and wet nature type of Denmark in figure
<a href="#fig:PlotNature">2.1</a>

<div class="figure">

<img src="man/figures/README-PlotNature-1.png" alt="Areas in denmark bellonging to dry and wet nature" width="100%" />

<p class="caption">

<span id="fig:PlotNature"></span>Figure 2.1: Areas in denmark bellonging
to dry and wet nature

</p>

</div>

Now we can use the `calculate_prop` to calculate the proportion of each
landuse in a certain radius, as an example we will use a radius of 200
meters to calculate the proportions of the nature raster created above:

``` r
proportions <- calculate_prop(Rast = nature, Radius = 200)
#> Starting to generate dummy stack [1/3]
#> 
|---------|---------|---------|---------|
=========================================
                                          

|---------|---------|---------|---------|
=========================================
                                          

|---------|---------|---------|---------|
=========================================
                                          

|---------|---------|---------|---------|
=========================================
                                          
#> Calculating the weight matrix [2/3]
#> Generating final stack [3/3]
#> 
|---------|---------|---------|---------|
=========================================
                                          
```

We can see the result in figure <a href="#fig:propsdenmark">2.2</a>

``` r
plot(proportions, colNA = "black")
```

<div class="figure">

<img src="man/figures/README-propsdenmark-1.png" alt="Prportion of different habitat types within Denmark" width="100%" />

<p class="caption">

<span id="fig:propsdenmark"></span>Figure 2.2: Prportion of different
habitat types within Denmark

</p>

</div>
