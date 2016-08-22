import hudson.model.*
import hudson.node_monitors.*
import hudson.slaves.*
import java.util.concurrent.*
jenkins = Hudson.instance
// Adapted from https://wiki.jenkins-ci.org/display/JENKINS/Display+list+of+projects+that+were+built+more+than+1+day+ago.
// Define hour to compare (hour=24 will find builds that were built more than 1 day ago)
hour=24;
minute=60;
second=60;
oneDayInSecond=hour*minute*second;
now=Calendar.instance;
list=[];

println("The build is run at ${now.time}");

for (item in jenkins.items){
   println("\t ${item.name}");
   // Ignore project that contains freeze or patch case insensitive
   if (item.name ==~ /(?i)(freeze|patch).*/){
       println("\t Ignored as it is a freeze or patch build");
    }else if (!item.disabled&&item.getLastBuild()!=null){
       build_time=item.getLastBuild().getTimestamp();
      if (now.time.time/1000-build_time.time.time/1000>oneDayInSecond){
          println("\t\tLast build was built in more than ${hour} hours ago");
          println("\t\tLast built was at ${build_time.time}");
          list<< item;
      }
   }else if (item.disabled){
        println("\t\tProject is disabled"); 
   }
} 

if (list.size()>0){
  println("Please take a look at following projects:");
  for (item in list){
     println("\t ${item.name}"); 
  }
  return 1;
}
