# Useful utilities
import os
import sys
import pandas as pd
import databento as dbn


def dbns_to_df(client, path, dbn_files):
    import os
    import sys
    dfs = []
    # load[ all the files into a single DBNStore object
    for file in dbn_files:
        stored_data = dbn.DBNStore.from_file(os.path.join(path, file))
        dfs.append(stored_data.to_df())
    
    # concatenate the dataframes
    df = pd.concat(dfs)

    # there should be a ts_event index or column. let's find out.
    if 'ts_event' in df.columns:
        # create a column from the index and index on ts_event
        df[df.index.name] = df.index
        df.set_index('ts_event', inplace=True)
    # df = df.sort_index(inplace=True)
    return df


def to_local_tz(df, sort_by=['ts_event'], tz='US/Pacific'):
    df.sort_values(by=sort_by, inplace=True)
    df['ts_event'] = df.index
    df['ts_event_tz'] = pd.to_datetime(df['ts_event'], unit='s', utc=True).dt.tz_convert(tz)
    df.set_index('ts_event_tz', inplace=True)
    return df