#!/bin/sh
tempo=$(date +"%d_%m_%Y-%H:%M:%S")

# Validando se o campo esta vazio
if [ -z $1 ]  || [ -z $2 ]
then
   echo "Favor informar o numero da porta e a lista de IPs!"
   echo "Use ./nmap-script-linux.sh <PORTA> <ARQUIVO COM OS IPs>"
else

clear

echo "****************************************************"
echo "|             Port Scan em bash script             |"
echo "|                   Engine: Nmap                   |"
echo "|                                                  |"
echo "|                 Autor: O Analista                |"
echo "|          E-mail: falecom@oanalista.com.br        |"
echo "|        website: http://www.oanalista.com.br      |"
echo "****************************************************"
echo ""

Inicio=$(date +%s.%N);

# Lendo cada endereco IP existente no arquivo
for i in $( cat /opt/scans/$2 ); do

# Roda o Nmap em cada IP encontrado no arquivo e redireciona o resultado para um arquivo de log
     nmap -P0 -p $1 $i >> /opt/scans/scanreport-$tempo.log


# Procurando por determinada string dentro do arquivo de log
     STATUS1=$(egrep -i 'open' /opt/scans/scanreport-$tempo.log | wc -l)	
     STATUS2=$(egrep -i 'closed' /opt/scans/scanreport-$tempo.log | wc -l)
     STATUS3=$(egrep -i 'filtered' /opt/scans/scanreport-$tempo.log | wc -l)

     if [ $STATUS1 = 1 ]
     then	
		echo "Servidor: $i | Porta: $1 | Status: ABERTA"
		echo "Data e hora da varredura: $tempo" >> /opt/scans/status-UP-$tempo.log
		echo "Servidor: $i | Porta: $1 | Status: ABERTA" >> /opt/scans/status-UP-$tempo.log
		echo "**************************************************" >> /opt/scans/status-UP-$tempo.log
     fi
	
     if [ $STATUS2 = 1 ]
     then
		echo "Servidor: $i | Porta: $1 | Status: FECHADA"
		echo "Data e hora da varredura: $tempo" >> /opt/scans/status-DOWN-$tempo.log
		echo "Servidor: $i | Porta: $1 | Status: FECHADA" >> /opt/scans/status-DOWN-$tempo.log
		echo "**************************************************" >> /opt/scans/status-DOWN-$tempo.log
     fi
   
     if [ $STATUS3 = 1 ]
     then
                echo "Servidor: $i | Porta: $1 | Status: FILTRADA"
                echo "Data e hora da varredura: $tempo" >> /opt/scans/status-FILTRADA-$tempo.log
                echo "Servidor: $i | Porta: $1 | Status: FECHADA" >> /opt/scans/status-FILTRADA-$tempo.log
                echo "**************************************************" >> /opt/scans/status-FILTRADA-$tempo.log
     fi
       
done
dur=$(echo "$(date +%s.%N) - $Inicio" | bc);
echo ""
echo "Arquivo utilizado: $2"
printf "Tempo=%.3f\n" $dur
fi
