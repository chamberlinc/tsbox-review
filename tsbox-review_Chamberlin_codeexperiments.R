#####################################################
### Experimental Code for Review of package tsbox ###
### Reviewer: Cathy Chamberlin                    ###
### Review Date: 2021-12-03                       ###
#####################################################

library(tsbox)

library(dataRetrieval)
library(dygraphs)
library(dplyr)
library(tidyr)

# I am downloading hydrological data timeseries from the USGS. This is my most frequent way of accessing timeseries data. Data comes as a data frame.
Eno_discharge <- readNWISuv(
  siteNumbers = "02085070",
  parameterCd = "00060",
  startDate = "2019-01-01",
  endDate = "2021-01-01"
)

# View the structure of the data frame
str(Eno_discharge)

# I often use dygraphs to create interactive plots to explore data.
dygraph(ts_xts(Eno_discharge)) %>% dyRangeSelector()

str(ts_xts(Eno_discharge))

# Trying using the package with a data frame of multiple parameters
Conn_discharge_DO <- readNWISuv(
  siteNumbers = "01193050",
  parameterCd = c("00060", "00300"),
  startDate = "2019-01-01",
  endDate = "2021-01-01"
)

str(Conn_discharge_DO)

# Try viewing both parameters together
try(str(ts_xts(Conn_discharge_DO)))
try(str(ts_xts(ts_long(Conn_discharge_DO))))
try(expr = {
  dygraph(ts_xts(Conn_discharge_DO)) %>% dyRangeSelector()
}
)

try({dygraph(ts_xts(Conn_discharge_DO)) %>% dyRangeSelector()})
try({dygraph(ts_xts(ts_long(Conn_discharge_DO))) %>% dyRangeSelector()})

try({str(
  ts_xts(
    pivot_longer(
      Conn_discharge_DO,
      cols = c("X_00060_00000", "X_00300_00000"),
      names_to = "Parameter"
    )
  )
)
})

try({dygraph(
  ts_scale(
    ts_xts(
      pivot_longer(
        Conn_discharge_DO,
        cols = c("X_00060_00000", "X_00300_00000"),
        names_to = "Parameter"
      )
    )
  )
)%>%
  dyRangeSelector()
})

# Try viewing the discharge data using the ts_plot function
try({ts_plot(Eno_discharge)})
try({ts_plot(Eno_discharge, skip_absent=TRUE)})


# Another issue I frequently run into is reading data from csv files to data frames where the DateTime is read in as a character string
character_date_dat <- data.frame(
  DateTime = c(
  "2011-11-11 11:11:11", "2012-12-12 12:12:12", "2021-09-25 20:07:00"
  ),
  Value = c(1, 2, 8)
)

# Trying to plot the data without having to convert the character string to POSIXct
try({with(character_date_dat, plot(Value ~ DateTime))})
with(character_date_dat, plot(Value ~ as.POSIXct(DateTime)))
try({ts_plot(character_date_dat)})
