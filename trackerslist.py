import os
import time,random,shutil
import wget

dir = os.path.dirname(os.path.abspath(__file__))
tmp = dir + "/tmp/"
input_file = dir + "/trackers.link"
output_file = dir + "/trackerslist.txt"

def merge(_tmp,_output_file):
	filelist = os.listdir(_tmp)
	with open(_output_file,'w',encoding='utf-8') as f:
		for filename in filelist:
			filepath = _tmp + "/" + filename
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
		time.sleep(random.random()*60)

def Remove_duplicates(_file):
	file = open(_file,"r")
	lines = file.readlines()
	lines = [string.replace("|","\|") for string in lines]
	lines = list(set(lines))
	file.close()
	newfile = open(_file,"w")
	newfile.writelines(lines)
	newfile.close()

download_file(tmp,input_file)
merge(tmp,output_file)
Remove_duplicates(output_file)
