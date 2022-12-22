mkdir reports
pabot --processes %4 -T -d reports --variable env:%1 --variable remote:%2 -i %3 testsuites
