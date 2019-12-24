# BIM - Dockerised BIMserver

The source contains Docker file and other script for creating docker image and deployable Docker containers of the open-source [BIMserver] (http://bimserver.org/) project.

Released under the terms of the Apache Licence v2.0, see "LICENCE.md" for more information and "THIRDPARTY.md" for details on licensed dependencies/integrated applications.

Docker Compose
==============
![Docker Compose](logo.png?raw=true "Docker Compose Logo")

Compose is a tool for defining and running multi-container Docker applications.
With Compose, you use a Compose file to configure your application's services.
Then, using a single command, you create and start all the services
from your configuration.



## Usage

'HOME\_DIR' is the directory (user-provided) that will contain the BIMserver's home directory (database, configuration, cache etc...). Substitute this placeholders as you see fit. Use persistent storage as well! The example below runs the container server on port 8888 on the host machine.

```
docker run --rm -it -v "HOME_DIR":"/schemas" -p 8888:8080 nhbs/bimserver
```

## Notes

The BIMserver requires enough memory allocated to the Docker container to handle serialisation/deserialisation/geometry generation of IFC model files, make sure you use enough to prevent crashes.

See the [BIMserver wiki](http://github.com/opensourceBIM/BIMserver/wiki/) for more instructions on the use of BIMserver.

