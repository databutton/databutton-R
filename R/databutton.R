library(httr)
library(tidyverse)
library(R6)

FIREBASE_CONFIG = list(
  apiKey= "AIzaSyAdgR9BGfQrV2fzndXZLZYgiRtpydlq8ug",
  authDomain= "databutton.firebaseapp.com",
  projectId= "databutton",
  storageBucket= "databutton.appspot.com",
  databaseURL= "")

url_signing_service_url <- "https://europe-west1-databutton.cloudfunctions.net/generateSignedUrl"
databutton_url    <- sprintf("https://securetoken.googleapis.com/v1/token?key=%s", FIREBASE_CONFIG['apiKey'])
databutton_bucket <- sprintf("https://firebasestorage.googleapis.com/v0/b/%s", FIREBASE_CONFIG['storageBucket'])

#' Databutton Client
#'
#' @description
#' A class to interact with Databutton boards.
#'
#' @details
#' You can push and pull artifacts to and from the board.

Databutton <- R6Class("Databutton",public = list(


      token = NULL,

      id_token = NULL,


      #' @description
      #' Create a new Databutton Client
      #' @param token Auth token - can be found in the board.
      #' @return A new `Databutton` object.
      initialize= function(token)
      {
          self$token <- token
          self$authenticate()
      },

      #' @description
      #' Authenticate with Databutton
      #' @return Authentification status
      authenticate = function()
      {
        url_body = list(grant_type= "refresh_token", "refresh_token" = self$token)
        json_body = jsonlite::toJSON(url_body, auto_unbox = TRUE)
        re = POST(databutton_url, body = json_body, encode = "raw")
        self$id_token <- content(re)$id_token

        return(http_status(re))
      },



      #' @description
      #' Pull a Dataframe from a Databutton board
      #' Will download a table from a given Databutton board as data frame
      #' @param board_id The board ID, can be found when inspecting the table in Databutton
      #' @param table_id The table ID, can be found when inspecting the table in Databutton
      #' @return data frame representation of the table
      get_data_frame = function(board_id, table_id)
      {
        re = GET(url_signing_service_url,
                  query=list(boardId= board_id, tableId = table_id),
                add_headers(authorization = sprintf("Bearer %s",self$id_token)))

        data = read_csv(content(re)$url[1])

        return(data)
      },


      #' @description
      #' Pull a Dataframe from a Databutton board
      #' Will download a table from a given Databutton board as data frame
      #' @param data_frame A Data Frame with the data to update the table_id with
      #' @param board_id The board ID, can be found when inspecting the table in Databutton
      #' @param table_id The table ID, can be found when inspecting the table in Databutton
      #' @return data frame representation of the table
      push_data_frame = function(data_frame, board_id, table_id)
      {
        #Write Data Frame on csv format as a string
        csv_string = format_csv(data_frame)

        # Define URL
        path = sprintf("boards/%s/table/%s", board_id, table_id)
        url  = sprintf("%s/o?name=%s", databutton_bucket, path)

        # Make the post call
        re = POST(url,
                   body=csv_string,
                   add_headers(Authorization= sprintf("Firebase %s", self$id_token),
                                                      "Content-type" = "text/csv"),
                               encode="raw")

        # Raise error if not successful
        warn_for_status(re)

        return(http_status(re))
      }



      )
)

