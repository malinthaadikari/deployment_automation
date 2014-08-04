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

#get the configurations details of the deployment
doc = libxml2.parseFile('configuration.xml')

#creating instaces one by one
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

        #we shutdown the instance just after create it to avoid running the puppet deamon
	instanceID=(instanceList[i].instances[0]).id
	conn.stop_instances(instance_ids=[instanceID])
        i=i+1

#we turn on all the machines after creating all instances
time.sleep(10)
j=0;
while(j<len(instanceList)):
	instance = conn.get_all_instances(instance_ids=[(instanceList[j].instances[0]).id])
	instance[0].instances[0].start()
	j=j+1
