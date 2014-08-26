from novaclient.v1_1 import client
import libxml2
import time
from credentials import get_nova_creds
from subprocess import call

i=0
instanceList=[]

#this dictionary contains the IP addresses of the populated instances
ipmap = {}

#get the configurations details of the deployment
doc = libxml2.parseFile('conf.xml')


creds = get_nova_creds()
nova = client.Client(**creds)
flavor = nova.flavors.find(name="m1.medium")
image = nova.images.find(name="DeploymentAutomationImageV3")
networkID = "34c6cbf5-5647-4210-8979-67e0b3b1f88a"

for node in doc.xpathEval("//node"):
	server = nova.servers.create(name = node.prop('id'),password="malintha",image= image.id,flavor= flavor.id ,key_name = "adikarikey",nics = [{'net-id': '34c6cbf5-5647-4210-8979-67e0b3b1f88a' ,'v4-fixed-ip': ''}])
	instanceList.append(server)
	time.sleep(10)
	print instanceList[i].status
	floating_ip = nova.floating_ips.create(nova.floating_ip_pools.list()[0].name)
	server.add_floating_ip(floating_ip)
	ipmap[node.prop('id')] =  (((instanceList[i].addresses)['network_automation'])[0])['addr']
        instanceID=instanceList[i].id
	instanceList[i].suspend()
        i=i+1
time.sleep(5)
j=0;

while(j<len(doc.xpathEval("//node"))):
        currentNode= doc.xpathEval("//node")[j]
        configFilepath = '/tmp/'+ ipmap[currentNode.prop('id')]
	xmlstring = currentNode.serialize('UTF-8', 1).replace('\n', '')
        t = xmlstring.format(**ipmap)
        f = open(configFilepath,'w+')
        f.write('configurations,'+ t)
        f.close()
        instanceList[j].resume()
	time.sleep(5)
	instanceList[j].reboot()
	call("while ! echo exit | nc "+ipmap[currentNode.prop('id')]+" 9443; do sleep 10; done", shell="True")	
	print "Server "+ipmap[currentNode.prop('id')]+" is running now"
	j=j+1
