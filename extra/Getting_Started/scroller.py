def scroller(index, quantity, timerange=timedelta(days=0), startdt="", enddt=""):
    print("Starting to scroll", end='')
    # Retrieve the datetimes, note that timerange has a higher priority
    if timerange.total_seconds() > 0:
        now = datetime.utcnow().replace(tzinfo=pytz.UTC)
        startdt = (now - timerange).isoformat()
        enddt = now.isoformat()
    
    # search the first page and write the result to data
    response = es.search(
        index=index,
        body={
                      "query": {
                        "bool": {
                          "must": [
                            {"range" : {
                                "phenomenonTime" : {
                                    #"gte": "2018-02-20T09:08:34.230693+00:00", 
                                    "gte": startdt,
                                    "lte": enddt, 
                                    "time_zone": "+01:00"
                                }
                            }},
                            {
                              "match_phrase": {
                                "Datastream.name.keyword": quantity
                              }
                            }
                          ]
                        }
                      }
                    },
        scroll='10m'
    )
    data = [[row["_source"]["phenomenonTime"], row["_source"]["result"]] for row in response['hits']['hits']]

    # Append new pages until there aren't any left
    while len(response['hits']['hits']):
        print(".", end='')
        # process results
        # print([item["_id"] for item in response["hits"]["hits"]])
        response = es.scroll(scroll_id=response['_scroll_id'], scroll='10m')
        data +=  [[row["_source"]["phenomenonTime"], row["_source"]["result"]] for row in response['hits']['hits']]
    
    # Convert data to a DataFrame and return it
    df = pd.DataFrame(data, columns=["phenomenonTime", quantity])
    # df.index = pd.to_datetime(df["phenomenonTime"].map(lambda t: t.split(".")[0]), utc=True)
    df.index = pd.to_datetime(df["phenomenonTime"].map(lambda t: roundto(t, 1)), utc=True)
    df = df.drop(["phenomenonTime"], axis=1)
    print("\nFetched {} tuples.".format(df.shape[0]))
    return df

def roundto(string, n):
    base = string.split(".")[0]
    if n > 0:
        base += "." + string.split(".")[1][:n]
    return base
