import boto
import boto.ec2
import time
import libxml2

region = boto.ec2.regioninfo.RegionInfo(name="nova" , endpoint="192.168.16.252")
conn = boto.connect_ec2(aws_access_key_id="b316892146764b44b20ee881e242d5de",
                                aws_secret_access_key="47df574bcdbb4bb48cc80c582c9b6d18",
                                is_secure=False,
                                region=region,
                                port=8773,
                                path="/services/Cloud")
i=0
instanceList=[]
doc = libxml2.parseFile('configuration.xml')
for node in doc.xpathEval("//node"):
        xmlstring = node.serialize('UTF-8', 1).replace('\n', '')
        f = open('/tmp/configdata','w')
        f.write('configurations,'+xmlstring)
        f.close()
        myInstance=conn.run_instances('ami-000000a7',min_count=1,max_count=1, instance_type = 'm1.small',key_name='adikari')
	instanceList.append(myInstance)
        while (instanceList[i].instances[0]).update() != "running":
     	      print (instanceList[i].instances[0]).update()
     	      time.sleep(2)
        print (instanceList[i].instances[0]).ip_address
        i=i+1
