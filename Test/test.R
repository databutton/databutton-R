library(databutton)


# Create client and authenticate
databutton = Databutton$new(token="AFxQ4_pU2l3AiRZZHjfaTnxwuIvWEcTzEdJs2lu2iK7XclP12swD1qR5PZP6tULbPcCzu8gbhXztkCca7ys94EXOewUpqdqahLRMoqBX270iLha138LWH4kOq1cQWyxuz0kw2BGURQI8p-ihq0Ed2SGVfzjAZMWBpRXtP-K7bVURWF7nJnPZXSx9se1YmeXKyGxqe_pgbqWk7aed5Fuj0kfjIXgVueR3LNHfNsqDQT9gk6eWfL49XagHMy_INzWBhlvBon60ZMXXcVEBacM79AwTkAejziDx2fJnifbYRtkENGTvTYWuEZzjt_AFbbKuoIfivf7Va8W-zbIIEXNfBzLy4bHVLywLyqpFN_VGiN9ovua1Y5JDVO84hpspvE2vsdHGVD4Y-6A7IQjyFXloXvbHaxz9INuExQ")


# Pull Dataframe from Board
board_id <- "USsqqevH9Yh8AA5NNHLk"
table_id <- "SDRO03nMwld1o7PWmYOEc"
df <- databutton$get_data_frame(board_id, table_id)


# Make a change to the Data Frame
df[2,2]=df[2,2]*10


# Push data frame to board
databutton$push_data_frame(df, board_id, table_id)

