# docker-base
Simple Docker boilerplate with .env configuration. Simplify Commands with makefile.  
You should modify the .env and the docker-compose.yml for your project.

First run: 

```make init```

Then:
```
make start
make stop
```

All Commands with ```make list```.

## Create Projects
Go to public directory, delete all files and run the commands from 
commandline or if you need a special php Version from inside the container 
after run ```make bash```.

###TYPO3
```
composer create-project typo3/cms-base-distribution . ^8

composer create-project typo3/cms-base-distribution . ^9
```

### Symfony
```
composer create-project symfony/skeleton .
composer create-project symfony/website-skeleton .
composer create-project symfony/symfony-demo .
```

### Neos
Change WEB_DOCUMENT_ROOT in .env to '/app/Web/'
```
composer create-project neos/neos-base-distribution .
composer create-project --no-dev neos/neos-base-distribution .
```