
# notice that this script is ok only
# for doc-v2.0. For manual generated on travis one should
# make sure they are not overwritten later by travis itself

for file in $(find . -name "*.html")
do

awk '{
  if(done){print; next;}
  print
  if(match($0,".*<head>.*")){
    print "<meta name=\"robots\" content=\"noindex\">"
    done=1;
  }
}END{
if(!done) print "error: head not present in " FILENAME > "/dev/stderr"
}' $file > $$
mv $$ $file

done
