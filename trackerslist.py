import os,re
import time,random,shutil
import wget

dir = os.path.dirname(os.path.abspath(__file__))
config = os.path.dirname(dir) + "\\aria2.conf"
tmp = dir + "\\.tmp\\"
input_file = dir + "\\trackers.link"
output_file = dir + "\\trackerslist.txt"

def merge(_tmp,_output_file):
	filelist = os.listdir(_tmp)
	with open(_output_file,'w',encoding='utf-8') as f:
		for filename in filelist:
			filepath = _tmp + "\\" + filename
			for line in open(filepath):
				f.writelines(line)
			f.write('\n')

def download_file(_tmp,_input_file):
	if os.path.exists(_tmp):
		shutil.rmtree(_tmp)
	os.makedirs(_tmp)
	f = open(_input_file,"r")
	links = f.readlines()
	f.close()

	for links in links:
		#print(links)
		wget.download(links,out=_tmp)
		t=random.randint(1,60)	
		print("\nWait for "+str(t)+" sec!")
		time.sleep(t)

def Remove_duplicates(_file):
	file = open(_file,"r")
	lines = file.readlines()
	lines = [string.replace('|','\|') for string in lines]
	lines = [string.replace('\n',',') for string in lines]
	lines = list(set(lines))
	file.close()
	newfile = open(_file,"w")
	newfile.writelines(lines)
	newfile.close()

def aria2_config(_config,_trackers):
	trackers = open(_trackers,'r',encoding='utf-8').readlines()
	trackers = "bt-tracker=" + str(trackers).replace('[\'','').replace('\']','')
	file = open(_config,'r',encoding='utf-8')
	lines = file.readlines()	
	lines = [re.sub(r'^bt-tracker=.*',trackers,string) for string in lines]
	file.close()
	file = open(_config,'w',encoding='utf-8')
	file.writelines(lines)
	file.close()
	
#download_file(tmp,input_file)
merge(tmp,output_file)
Remove_duplicates(output_file)
aria2_config(config,output_file)