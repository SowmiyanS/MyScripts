#!/bin/bash
certfile="../Downloads/mec-certificate.crt"
certname="mec root ssl certificate"
for certDB in $(find ~/ -name "cert8.db")
do
	certdir=$(dirname ${certDB});
	certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d dbm:${certdir}
done
for certDB in $(find ~/ -name "cert9.db")
do
	certdir=$(dirname ${certDB});
	certutil -A -n "${certname}" -t "TCu,Cu,Tu" -i ${certfile} -d sql:${certdir}
done

