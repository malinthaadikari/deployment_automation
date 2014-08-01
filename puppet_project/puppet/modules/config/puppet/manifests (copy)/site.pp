import 'filecopy'
import 'config'


node 'puppetclient','ubuntu' {

	include change_config
}
 
#node 'ubuntu' {

#	include setupESB
#}
 
