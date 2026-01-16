# rshiny-test
A test Rshiny Dashboard

## Overview

This repository contains an example Shiny dashboard that displays sales data with interactive visualizations and a data table.

## Features

- **2 Interactive Plots:**
  - Sales by Product (Bar Chart)
  - Revenue Distribution by Region (Box Plot)
- **1 Data Table:** Displays the complete dataset with sorting and filtering capabilities
- **CSV Input:** Upload custom CSV files or use the provided sample data

## Files

- `app.R` - Main Shiny application file
- `sample_data.csv` - Sample sales data for demonstration

## Installation

To run this dashboard, you need to have R installed along with the following packages:

```r
install.packages("shiny")
install.packages("ggplot2")
install.packages("DT")
```

## Running the Dashboard

1. Clone this repository:
```bash
git clone https://github.com/jpalmer37/rshiny-test.git
cd rshiny-test
```

2. Open R or RStudio and run:
```r
shiny::runApp()
```

Alternatively, in RStudio, you can open `app.R` and click the "Run App" button.

## Data Format

The CSV file should contain the following columns:
- `date` - Date of the transaction
- `product` - Product name
- `sales` - Number of units sold
- `revenue` - Revenue amount
- `region` - Geographic region
- `customer_satisfaction` - Customer satisfaction rating

## Usage

1. By default, the dashboard loads `sample_data.csv`
2. To use your own data, uncheck "Use Default Sample Data" and upload a CSV file
3. Navigate between the "Plots" and "Data Table" tabs to explore the data
