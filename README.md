## Title

### Postgres with Docker

#### Running Postgres with Docker

```bash
export HOST_DATA_DIRECTORY="/home/saurabh/PycharmProjects/leetcode-pyspark/postgres_docker/data"

mkdir $HOST_DATA_DIRECTORY/postgres_data

docker run -it \
  -e POSTGRES_USER="postgres" \
  -e POSTGRES_PASSWORD="postgres" \
  -e POSTGRES_DB="leetcodedb" \
  -u $(id -u):$(id -g) \
  -v $HOST_DATA_DIRECTORY/postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:latest
```

If you want to reset your database, just delete the `postgres_data` folder

#### Loading leetcode dump file using psql

Installing `psql`
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
export DUMP_FILE_PATH="/home/saurabh/PycharmProjects/leetcode-pyspark/postgresql_dump_file/leetcodedb.sql"

pg_restore --host localhost --port 5432 --username postgres --dbname leetcodedb --verbose $DUMP_FILE_PATH
```



