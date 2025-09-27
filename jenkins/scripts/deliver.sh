#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins'"'"'s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
# Instalacja projektu do lokalnego repozytorium Mavena
# (przy okazji uruchamia też help:evaluate, aby upewnić się że POM jest parsowany)
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'The following command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project'"'"'s "pom.xml" file.'
set -x
# Pobieramy wartość <name/> z pom.xml
# Uwaga: Maven może dorzucać kody kolorów ANSI i znak końca linii
# → tr -d '\r\n' usuwa \r i \n
# → sed -r "s/\x1B\[[0-9;]*[a-zA-Z]//g" usuwa kody kolorów
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name | tr -d '\r\n' | sed -r "s/\x1B\[[0-9;]*[a-zA-Z]//g")
set +x

echo 'The following command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
# Pobieramy wartość <version/> z pom.xml
# Tutaj stosujemy tę samą technikę czyszczenia jak wyżej
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version | tr -d '\r\n' | sed -r "s/\x1B\[[0-9;]*[a-zA-Z]//g")
set +x

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'
set -x
# Uruchamiamy JAR zbudowany przez Mavena
# Dzięki NAME i VERSION mamy poprawną nazwę artefaktu
java -jar target/${NAME}-${VERSION}.jar
