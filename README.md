# databutton-R

## Installation

```R
library(devtools)
install_github("databutton/databutton-R")
```

## Initialize a client

You can get your token at https://app.databutton.io by clicking the dropdown next to your username and click "Copy auth token".

```R
library(databutton)

databutton = Databutton$new(token=TOKEN)
```

## Pull down an existing table as a dataframe

You can get the `board_id` and the `table_id` from going to a table in Databutton!

```R
df = databutton$get_data_frame(board_id=board_id, table_id=table_id)
```

## Push a dataframe to an existing table in Databutton

```R
df <- data.frame (first_column  = c("tom", "nick", "juli"),
                  second_column = c(10, 15, 14)
                  )

# Get the board_id and table_id from the datatabutton URL
board_id = 'board_id' 
table_id = 'table_id'

databutton$push_data_frame(df, board_id, table_id)
```



Happy hacking!
