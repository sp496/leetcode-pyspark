# Title

### Postgres with Docker

#### Running Postgres with Docker

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
  postgres:latest
```
If you want to reset your database, just delete the `postgres_data` folder


#### Running Postgres with pgadmin (optional)

Create a network

```bash
docker network create pg-network
```

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
  --network=pg-network \
  --name pg-database \
  postgres:latest
```

Launching pgadmin (optional)

```bash
#Path to a data directory in the host machine
export HOST_DATA_DIRECTORY="/home/saurabh/PycharmProjects/leetcode-pyspark/postgres_docker/data"

#creating direcory for postgres data if it doesn't exist already
mkdir -p $HOST_DATA_DIRECTORY/pgadmin_conn_data

sudo chown -R 5050:5050 $HOST_DATA_DIRECTORY/pgadmin_conn_data

docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  -v $HOST_DATA_DIRECTORY/pgadmin_conn_data:/var/lib/pgadmin \
  --network=pg-network \
  --name pgadmin \
  dpage/pgadmin4
```


#### Loading leetcode dump file using psql

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
(This needs to be done only once)
```bash
#path to dump file
export DUMP_FILE_PATH="/home/saurabh/PycharmProjects/leetcode-pyspark/postgresql_dump_file/leetcodedb.sql"

pg_restore --host localhost --port 5432 --username postgres --dbname leetcodedb --verbose $DUMP_FILE_PATH
```

### Running solutions

#### Download jar file for postgres jdbc driver

#### Update `config.ini` in `config/config.ini` folder

You need a python interpreter with pyspark package installed to run the solutions
#### Running from PyCharm
Just open the project root directory as a PyCharm project and you should be able to run the solutions

#### Running from terminal
Append your project root directory path to the PYTHONPATH
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


# For Windoes

### Postgres with Docker

#### Running Postgres with Docker

```cmd
REM Path to a data directory in the host machine
set HOST_DATA_DIRECTORY=C:\Users\DELL\PycharmProjects\leetcode-pyspark\postgres_docker\data

REM Creating directory for postgres data if it doesn't exist already
if not exist "%HOST_DATA_DIRECTORY%\postgres_data" mkdir "%HOST_DATA_DIRECTORY%\postgres_data"

REM Running Docker container
docker run -it ^
  -e POSTGRES_USER="postgres" ^
  -e POSTGRES_PASSWORD="postgres" ^
  -e POSTGRES_DB="leetcodedb" ^
  -v "%HOST_DATA_DIRECTORY%\postgres_data:/var/lib/postgresql/data" ^
  -p 5432:5432 ^
  postgres:latest
```
If you want to reset your database, just delete the `postgres_data` folder

#### Loading leetcode dump file using psql

Install `psql`
In powershell
```bash
wsl -install
```

```bash
sudo apt-get update
sudo apt-get install -y postgresql-client
```
Connect to your database, password is postgress
```bash
psql -h localhost -p 5432 -U postgres -d leetcodedb
```

Show tables
`\dt`

Quit
`\q`

Load data from dump file
(This needs to be done only once)
```bash
#path to dump file
export DUMP_FILE_PATH="/mnt/c/Users/DELL/PycharmProjects/leetcode-pyspark/postgresql_dump_file/leetcodedb.sql"

pg_restore --host localhost --port 5432 --username postgres --dbname leetcodedb --verbose $DUMP_FILE_PATH
```

### Running solutions

#### Download jar file for postgres jdbc driver

#### Update `config.ini` in `config/config.ini` folder

You need a python interpreter with pyspark package installed to run the solutions
#### Running from PyCharm
Just open the project root directory as a PyCharm project and you should be able to run the solutions

#### Running from terminal
Append your project root directory path to the PYTHONPATH
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





