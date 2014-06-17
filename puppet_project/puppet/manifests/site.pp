import 'filecopy'



node 'puppetclient' {

	include myFile
}
 
node 'ubuntu' {

	include setupESB
}
 
