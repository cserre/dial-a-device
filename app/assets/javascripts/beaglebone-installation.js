function initialize(){

  // dellogfiles();

  console.log ("start initialization");
        

  is = setInterval (function steps()
     {
        var asj = require('bonescript');
        asj.readTextFile('/var/lib/cloud9/autorun/Step-1.js', printStatus);
        function printStatus(asj)
          {
            var asl = require('bonescript');
          asl.readTextFile('/var/lib/cloud9/dial-a-device-bb-1.log', printStatus);
          function printStatus(asl)
          {
            var as = require('bonescript');
          as.readTextFile('/var/lib/cloud9/dial-a-device-bb-1.status', printStatus);
          function printStatus(as)
          { 
           var bsj = require('bonescript');
          bsj.readTextFile('/var/lib/cloud9/autorun/Step-2.js', printStatus);
          function printStatus(bsj)
            {
              var bsl = require('bonescript');
            bsl.readTextFile('/var/lib/cloud9/dial-a-device-bb-2.log', printStatus);
            function printStatus(bsl)
            { 
              var bs = require('bonescript');
            bs.readTextFile('/var/lib/cloud9/dial-a-device-bb-2.status', printStatus);
            function printStatus(bs)
            { 
             var csj = require('bonescript');
            csj.readTextFile('/var/lib/cloud9/autorun/Step-3.js', printStatus);
            function printStatus(csj)
            {
              var csl = require('bonescript');
            csl.readTextFile('/var/lib/cloud9/dial-a-device-bb-3.log', printStatus);
            function printStatus(csl)
            { 
              var cs = require('bonescript');
            cs.readTextFile('/var/lib/cloud9/dial-a-device-bb-3.status', printStatus);
            function printStatus(cs)
            { 
             var dsj = require('bonescript');
            dsj.readTextFile('/var/lib/cloud9/autorun/Step-4.js', printStatus);
            function printStatus(dsj)
            {

              var dsl = require('bonescript');
            dsl.readTextFile('/var/lib/cloud9/dial-a-device-bb-4.log', printStatus);
            function printStatus(dsl)
            {
              var ds = require('bonescript');
            ds.readTextFile('/var/lib/cloud9/dial-a-device-bb-4.status', printStatus);
            function printStatus(ds)
            { 
             var esj = require('bonescript');
            esj.readTextFile('/var/lib/cloud9/autorun/Step-5.js', printStatus);
            function printStatus(esj)
              {
                var esl = require('bonescript');
              esl.readTextFile('/var/lib/cloud9/dial-a-device-bb-5.log', printStatus);
              function printStatus(esl)
                {
                var es = require('bonescript');
              es.readTextFile('/var/lib/cloud9/dial-a-device-bb-5.status', printStatus);
              function printStatus(es)
                { 
                 var fsj = require('bonescript');
                fsj.readTextFile('/var/lib/cloud9/autorun/Step-6.js', printStatus);
                function printStatus(fsj)
                  {
                    var fsl = require('bonescript');
                  fsl.readTextFile('/var/lib/cloud9/dial-a-device-bb-6.log', printStatus);
                  function printStatus(fsl)
                  {
                    var fs = require('bonescript');
                  fs.readTextFile('/var/lib/cloud9/dial-a-device-bb-6.status', printStatus);
                  function printStatus(fs)
                  {
                    if(asj.data != null){
                  if(as.data == "completed"){
                    if(bsj.data != null){
                      if(bs.data =='completed'){
                        if(csj.data != null){
                        if (cs.data == 'completed'){
                          if(dsj.data != null){
                          if (ds.data =='completed'){
                            if(esj.data != null){
                            if (es.data=='completed'){
                              if(fsj.data != null){
                               if (fs.data=='completed'){document.getElementById("step-status").innerHTML = ''}
                              else{document.getElementById("step-status").innerHTML = '<img src="/assets/ajax-violet.gif" >&nbsp;Step 6/6' ;}
                            }else{step6();}
                              }else{document.getElementById("step-status").innerHTML = '<img src="/assets/ajax-violet.gif" >&nbsp;Step 5/6';}
                            }else{step5();}
                            }else{document.getElementById("step-status").innerHTML = '<img src="/assets/ajax-violet.gif" >&nbsp;Step 4/6';}
                          }else{step4();}
                          }else{document.getElementById("step-status").innerHTML = '<img src="/assets/ajax-violet.gif" >&nbsp;Step 3/6' ;}
                        }else{step3();}
                         }else{document.getElementById("step-status").innerHTML =  '<img src="/assets/ajax-violet.gif" >&nbsp;Step 2/6';}
                      }else{step2(); }
                    }else{document.getElementById("step-status").innerHTML = '<img src="/assets/ajax-violet.gif" >&nbsp;Step 1/6' ;}
                    }else{stepWriteServer(); step1();}

                  }
                  }
                }
              }
            }
            }
            }
            }
            }
            }
          }
          } }}}}}}


      function stepWriteServer() {

        var bs = require('bonescript');
        file = '/var/lib/cloud9/server.txt';
       bs.writeTextFile(file, document.location.host);

      }

      function step1(){
      var a = require('bonescript');
        file = '/var/lib/cloud9/autorun/Step-1.js';
       a.writeTextFile(file, "var exec = require ('child_process').exec; exec ('mkdir /var/lib/cloud9/ ; cd /var/lib/cloud9/ ; curl -k https://raw.github.com/Cominch/dial-a-device-node/master/README.md &> README.md; curl -k https://raw.github.com/Cominch/dial-a-device-node/master/README.md &> /var/lib/cloud9/dial-a-device-bb-1.log ;mkdir /var/lib/cloud9/autorun  ; echo -n \"completed\" &> /var/lib/cloud9/dial-a-device-bb-1.status; echo &> /var/lib/cloud9/autorun/Step-1.js', function(error, stdout, stderr) {console.log (stdout)});",readStatus);

      function printStatus(q) {
          console.log(JSON.stringify(q));
      }
      function readStatus(q) {
        a.readTextFile(file, printStatus);
      }
      }


      function step2(){
       var b = require('bonescript');
        file = '/var/lib/cloud9/autorun/Step-2.js';
       b.writeTextFile(file, "var exec = require ('child_process').exec; exec ('env GIT_SSL_NO_VERIFY=true git clone https://github.com/Cominch/dial-a-device-bb /var/lib/cloud9/dial-a-device-bb  &> /var/lib/cloud9/dial-a-device-bb-2.log; echo -n \"completed\" &> /var/lib/cloud9/dial-a-device-bb-2.status; echo &>  /var/lib/cloud9/autorun/Step-2.js', function(error, stdout, stderr) {console.log (stdout)});",readStatus);
        function printStatus(r) {
          console.log(JSON.stringify(r));
      }
      function readStatus(r) {
        b.readTextFile(file, printStatus);
      }
      }


      function step3(){
        var c = require('bonescript');
        file = '/var/lib/cloud9/autorun/Step-3.js';
       c.writeTextFile(file, "var exec = require ('child_process').exec; exec ('opkg update; opkg install python-compiler; opkg install python-misc; opkg install python-multiprocessing &> /var/lib/cloud9/dial-a-device-bb-3.log ; echo -n \"completed\" >/var/lib/cloud9/dial-a-device-bb-3.status; echo &>  /var/lib/cloud9/autorun/Step-3.js', function(error, stdout, stderr) {console.log (stdout)});",readStatus);

      function printStatus(t) {
          console.log(JSON.stringify(t));
      }
      function readStatus(t) {
        c.readTextFile(file, printStatus);
      }
      }


      function step4(){
      var d = require('bonescript');
        file = '/var/lib/cloud9/autorun/Step-4.js';
       d.writeTextFile(file, "var exec = require ('child_process').exec; exec ('npm update &> /var/lib/cloud9/dial-a-device-bb-4.log ; echo -n \"completed\" > /var/lib/cloud9/dial-a-device-bb-4.status; echo &>  /var/lib/cloud9/autorun/Step-4.js', function(error, stdout, stderr) {console.log (stdout)});",readStatus);
      function printStatus(y) {
          console.log(JSON.stringify(y));
      }
      function readStatus(y) {
        d.readTextFile(file, printStatus);
      }
      }


      function step5(){

      var e = require('bonescript');
        file = '/var/lib/cloud9/autorun/Step-5.js';
       e.writeTextFile(file, "var exec = require ('child_process').exec; exec ('npm install -g getmac forever-monitor dial-a-device-node  &> /var/lib/cloud9/dial-a-device-bb-5.log ;echo -n \"completed\" > /var/lib/cloud9/dial-a-device-bb-5.status; echo &>  /var/lib/cloud9/autorun/Step-5.js', function(error, stdout, stderr) {console.log (stdout)});",readStatus);
      function printStatus(u) {
          console.log(JSON.stringify(u));
      }
      function readStatus(u) {
        e.readTextFile(file, printStatus);
      }
      }


      function step6(){

      var f = require('bonescript');
        file = '/var/lib/cloud9/autorun/Step-6.js';
       f.writeTextFile(file, "var exec = require ('child_process').exec; exec ('cd /var/lib/cloud9/dial-a-device-bb ;env GIT_SSL_NO_VERIFY=true git pull &> /var/lib/cloud9/dial-a-device-bb-6.log ; cp forever.js /var/lib/cloud9/autorun/ ;echo -n \"completed\" > /var/lib/cloud9/dial-a-device-bb-6.status; echo &>  /var/lib/cloud9/autorun/Step-6.js', function(error, stdout, stderr) {console.log (stdout)});",readStatus);
      function printStatus(i) {
          console.log(JSON.stringify(i));
      }
      function readStatus(i) {
        f.readTextFile(file, printStatus);
      }
      }
      


    },1000);

function dellogfiles(){
  var del = require('bonescript');

    file = '/var/lib/cloud9/autorun/deletelogfiles.js';      
     del.writeTextFile(file, "var exec = require ('child_process').exec; exec ('rm /var/lib/cloud9/autorun/Step-1.js ;rm /var/lib/cloud9/autorun/Step-2.js ;rm /var/lib/cloud9/autorun/Step-3.js ;rm /var/lib/cloud9/autorun/Step-4.js ;rm /var/lib/cloud9/autorun/Step-5.js ;rm /var/lib/cloud9/autorun/Step-6.js ;rm /var/lib/cloud9/README.md ; rm -rf /var/lib/cloud9/dial-a-device-bb/ ;rm /var/lib/cloud9/dial-a-device-bb-1.log ; rm /var/lib/cloud9/dial-a-device-bb-2.log ; rm /var/lib/cloud9/dial-a-device-bb-3.log ; rm /var/lib/cloud9/dial-a-device-bb-4.log ; rm /var/lib/cloud9/dial-a-device-bb-5.log ; rm /var/lib/cloud9/dial-a-device-bb-6.log ; rm /var/lib/cloud9/dial-a-device-bb-1.status ; rm /var/lib/cloud9/dial-a-device-bb-2.status ; rm /var/lib/cloud9/dial-a-device-bb-3.status ; rm /var/lib/cloud9/dial-a-device-bb-4.status ; rm /var/lib/cloud9/dial-a-device-bb-5.status ; rm /var/lib/cloud9/dial-a-device-bb-6.status ; rm /var/lib/cloud9/autorun/forever.js ;  rm /var/lib/cloud9/autorun/deletelogfiles.js ;', function(error, stdout, stderr) {console.log (stdout)});",readstatus);

     function printstatus(k) {
      console.log(JSON.stringify(k));
  }
  function readstatus(k) {
    del.readTextFile(file, printstatus);
  }}
  

};




function checkStatus() {

            
 
 var b = require('bonescript');
 b.readTextFile('/var/lib/cloud9/autorun/forever.js', printStatus);

function printStatus(x)
 {
 var c = require('bonescript');
 c.readTextFile('/var/lib/cloud9/README.md', printStatus);

function printStatus(y)
 {
var d = require('bonescript');
 d.readTextFile('/var/lib/cloud9/autorun/Step-2.js', printStatus);

function printStatus(z)
 {
  var isInstalled = false;
  var isInstallationOngoing = false;
  var isinternetconnection =false;
  
    if(x.data != null){  //if forever.js exists
      if(x.data.length != 0)   //if forever.js is not empty
      {
        isInstalled = true;        
      }
  }
  
  if(z.data !=null){
 isInstallationOngoing = true;
}
  if(y.data !=null){ 
    isinternetconnection = true;
  }


 if (isInstallationOngoing) {

    if(isinternetconnection){

      if (isInstalled) { 
        document.getElementById("install-status").innerHTML = '<img src="/assets/greencheck.png" >&nbsp;The connected device is initialized and installed properly.&nbsp;'+ "<button onclick='initialize()' class='btn btn-warning'>Re-initialize</button>";
      } else{
          document.getElementById("install-status").innerHTML = "<img src='/assets/ajax-violet.gif' >&nbsp;The installation is ongoing and will take 5-10 min depending upon network connection.&nbsp;<button onclick='initialize()' class='btn btn-warning'>Re-Initialize</button>";
      }

    } else{

      document.getElementById("install-status").innerHTML ="<img src='/assets/error.png' >&nbsp;Error in Installation:Please check the internet connection and Re-Initialize.&nbsp;" + "<button onclick='initialize()' class='btn btn-danger'>Re-Initialize</button>";
    }
 

  } else {

        document.getElementById("install-status").innerHTML = "<img src='/assets/ajax-violet.gif' >&nbsp;The device connected needs to be initialized.&nbsp;"+ "<button onclick='initialize()' class='btn btn-success'>Initialize</button>";
      }



}

}
}

        }

