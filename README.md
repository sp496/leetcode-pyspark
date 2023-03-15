# Title

## Postgres with Docker

### Running Postgres with Docker

```bash
#Path to a data directory in the host machine
export HOST_DATA_DIRECTORY="/home/saurabh/PycharmProjects/leetcode-pyspark/postgres_docker/data"

#creating direcory for postgres data if it doesn't exist already
mkdir -p $HOST_DATA_DIRECTORY/postgres_data

docker run -it \
  -e POSTGRES_USER="postgres" \
  -e POSTGRES_PASSWORD="postgres" \
  -e POSTGRES_DB="leetcodedb" \
  -u $(id -u):$(id -g) \
  -v $HOST_DATA_DIRECTORY/postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --name pg-database \
  postgres:latest
```

If you want to reset your database, just delete the `postgres_data` folder

### Loading leetcode dump file using psql

Install `psql`
```bash
sudo apt-get install -y postgresql-client
```
Connect to your database
```bash
psql -h localhost -p 5432 -U postgres -d leetcodedb
```

Show tables
`\dt`

Quit
`\q`

Load data from dump file 
```bash
#path to dump file
export DUMP_FILE_PATH="/home/saurabh/PycharmProjects/leetcode-pyspark/postgresql_dump_file/leetcodedb.sql"

pg_restore --host localhost --port 5432 --username postgres --dbname leetcodedb --verbose $DUMP_FILE_PATH
```

## Running solutions


### Running from terminal
Add your project directory path to the PYTHONPATH
```bash
export PYTHONPATH=/home/saurabh/PycharmProjects/leetcode-pyspark:$PYTHONPATH
```

Navigate to your project direcory

```bash
cd /home/saurabh/PycharmProjects/leetcode-pyspark
```

Run python solution files
```bash
python dataframe_solutions/181.py 
```
