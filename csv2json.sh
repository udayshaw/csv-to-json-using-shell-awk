#!/bin/sh

file="jsonfile.json";
#echo "{" > $file;

rm -f $file

cat d3data_f.txt | sort | uniq > d3data_f.txt
#cat /opt/uday/d3data_f.txt | awk -F, '{print $1}' | sort | uniq
#cat /opt/uday/d3data_f.txt | awk -F, -v fil=$i '($1~/^fil$/){print $2}' | sort | uniq
#cp /opt/uday/d3data_f.txt /opt/uday/d3data_f1.txt;
#cp /opt/uday/d3data_f.txt /opt/uday/d3data_f2.txt
#cp /opt/uday/d3data_f.txt /opt/uday/d3data_f3.txt


for i in `cat d3data_f.txt | awk -F, '{print $1}' | sort | uniq`
do
   echo $i;
   echo '{"name": "'$i'","children":[' >> $file;
   for j in `cat d3data_f.txt | awk -F, '($1~/^'$i'$/){print $2}' | sort | uniq`
   do
      echo $i": "$j;
      echo '    {"name": "'$j'","children":[' >> $file;
      for k in `cat d3data_f.txt | awk -F, '($1~/^'$i'$/ && $2~/^'$j'$/){print $3}' | sort | uniq`
      do
        echo $i": "$j": "$k;
        echo '        {"name": "'$k'","children":[' >> $file;
        for l in `cat d3data_f.txt | awk -F, '($1~/^'$i'$/ && $2~/^'$j'$/ && $3~/^'$k'$/){print $4}' | sort | uniq`
        do
           echo $i": "$j": "$k": "$l;
#           lend=`tail -1n /opt/uday/d3data_f.txt | awk -F, '($1~/^'$i'$/ && $2~/^'$j'$/ && $3~/^'$k'$/){print $4}' | sort | uniq`;
           if [[ `cat d3data_f.txt | awk -F, '($1~/^'$i'$/ && $2~/^'$j'$/ && $3~/^'$k'$/){print $4}' | sort | uniq | tail -1`  == $l ]]
            then
               echo '            {"name": "'$l'","size": "'`cat d3data_f.txt | awk -F, '($1~/^'$i'$/ && $2~/^'$j'$/ && $3~/^'$k'$/ && $4~/^'$l'$/){print $5}'`'"}' >> $file;
            else
               echo '            {"name": "'$l'","size": "'`cat d3data_f.txt | awk -F, '($1~/^'$i'$/ && $2~/^'$j'$/ && $3~/^'$k'$/ && $4~/^'$l'$/){print $5}'`'"},' >> $file;
           fi;
        done
#        echo ']},' >> $file;
         if [[ `cat d3data_f.txt | awk -F, '($1~/^'$i'$/ && $2~/^'$j'$/){print $3}' | sort | uniq | tail -1` == $k  ]]
          then
            echo "        ]}" >> $file;
         else
            echo "        ]}," >> $file;
         fi;
      done
#      echo ']},' >> $file;
       if [[ `cat d3data_f.txt | awk -F, '($1~/^'$i'$/){print $2}' | sort | uniq | tail -1` == $j  ]]
       then
          echo "    ]}" >> $file;
       else
          echo "    ]}," >> $file;
       fi;
   done
   if [[ `cat d3data_f.txt | awk -F, '{print $1}' | sort | uniq | tail -1` == $i  ]] 
   then
      echo "]}" >> $file;
   else
      echo "]}," >> $file;
   fi;
done


