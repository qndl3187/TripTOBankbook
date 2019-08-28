# -*- coding: utf-8 -*-
"""
Created on Sun Aug 25 16:41:41 2019

@author: jihee
"""
import numpy as np
import random
import folium
from folium import plugins
from haversine import haversine
from selenium import webdriver 

import imgkit

course_default = [
                    ['현재위치', 37.537949, 126.992857], # starting point
                    ['마지막위치', 37.53183815, 126.9629496746], # arrival point
                    ['디큐브아트센터', 37.508323600000004, 126.8884274],
                    ['아쿠아플라넷63', 37.519815799999996, 126.94031389999999],
                    ['선유도공원', 37.5423833, 126.9018193]
                ]

course_time = {
            '현재위치': [0, 24, 43, 43, 34],
            '마지막위치': [21, 0,  37, 27, 40],
            '디큐브아트센터' : [42, 35, 0, 29, 23],
            '아쿠아플라넷63': [40, 23, 31, 0, 40],
            '선유도공원' : [35, 38, 24, 35, 0]
            }

global city_length
city_length = len(course_default)


def get_time_info(from_, to_):
    return course_time[course_default[from_][0]][to_]

def htmltopng(htmlfilename):
    my_path = "file:///C:/Users/jihee/.spyder-py3/"
    temp_name = my_path + htmlfilename
    driver = webdriver.Chrome()
    driver.get(temp_name)
    save_name = 'map_imageee.png'     
    driver.save_screenshot(save_name)
    driver.quit()

def map_marker(final_course):
    map_line = []
    map_course = folium.Map(location=[37.545905, 127.016015], zoom_start=12)
    cnt = 1
    for i in final_course:
        print(i, course_default[i][0])
        map_line.append([course_default[i][1], course_default[i][2]])
        my_location = [course_default[i][1], course_default[i][2]]
        if course_default[i][0] == '현재위치': icon = 'user'
        elif course_default[i][0] == '마지막위치' : icon = 'bed'
        else: icon = 'chevron-circle-down'
        
        folium.Marker(my_location, icon = plugins.BeautifyIcon(icon = icon, border_color='red', text_color='red'\
                      ,icon_shape = 'marker', border_width = 2),tooltip = str(cnt) + course_default[i][0]).add_to(map_course)
        cnt += 1
            
    folium.PolyLine(locations = map_line, color = 'red', weight=4, line_opacity = 1).add_to(map_course)
    htmlfilename = 'map_marker_test2.html'
    map_course.save(htmlfilename)
    htmltopng(htmlfilename)

def set_targets():
    result = []
    for i in course_default:
        temp = [i[1], i[2]]
        result.append(temp)   
    result = np.array(result)
    return result

def set_selfmen(men, maxmen):  
    result = []
    for number in range(maxmen):
        temp = np.array([0])
        tempman = np.arange(2, maxmen+1, dtype = np.int)
        np.random.shuffle(tempman)
        temp = np.append(temp, tempman)
        temp = np.append(temp, [1])        
        result.append(temp)
    result = np.array(result)
    return result

def deletebfroma(a,b):
    index = np.array([], dtype = np.int16)
    for number in range(len(a)):
        if a[number] in b:
            index = np.append(index, number)
    return np.delete(a, index)


class salesman(object):
    
    def __init__(self, xymax, numberofstops, maxmen, mutationrate,\
                 verbose = False, mutatebest = True):
        self.numberofstops = numberofstops  
        self.mutatebest = mutatebest 
        self.verbose = verbose
        self.maxmen = maxmen 
        self.xymax = xymax        
        self.mutationrate = mutationrate
        self.targets = set_targets()
        self.men = np.empty((maxmen, numberofstops), dtype = np.int)
        self.men = set_selfmen(self.men, self.maxmen)
        self.best = np.array(self.getbestsalesmen())[...,0][0]
        self.best = self.best.astype(np.int64)


    # 가장 최적의 루트를 리턴해준다. (Method that returns the best route at runtime)
    def getbestsalesmen(self):
        temporder = np.empty([len(self.men), 2], dtype = np.float)
        for number in range(len(self.men)):
            temporder[number] = [number, 0,]
            
        for number in range(len(self.men)):
            templength = 0
            for target in range(len(self.targets) - 1):
                """start_info = self.men[number][target]
                dest_info = self.men[number][target+1]
                diff = get_time_info(start_info, dest_info)"""
                start_info = (self.targets[self.men[number][target]][1],self.targets[self.men[number][target]][0])
                dest_info = (self.targets[self.men[number][target+1]][1],self.targets[self.men[number][target + 1]][0])
                diff = haversine(start_info, dest_info)
                templength = templength + diff
            
            temporder[number][1] = templength          
        temporder = sorted(temporder, key=lambda x: -x[1])
        return temporder[int(len(temporder)/2):]

    #function that breeds two route and returns the offspring
    
    def breed(self, parent1, parent2):
        global halflength
        start = 1
        dna1 = self.men[parent1][start:start+halflength] 
        dna2 = self.men[parent2][1:-1]
        dna2 = deletebfroma(dna2, dna1)     
        offspring = np.array([0])
        offspring = np.append(offspring, dna1)
        offspring = np.append(offspring, dna2)
        offspring = np.append(offspring, 1)
        return offspring



    # 새로운 개체를 생성 (fill the route up with new offspring)
    def breednewgeneration(self): 
        best = np.array(self.getbestsalesmen())[...,0]
        best = best.astype(np.int64)
        for i in range(len(self.men)):
            if i not in best:
                if (self.men[i][0] == 0 and len(np.where(self.men[i] == 0)[0]) == 1) and \
            ( self.men[i][city_length-1] == 1 and len(np.where(self.men[i] == 1)[0]) == 1):
                    self.men[i] = self.breed(i, i)

    #mutate route 돌연변이
    def mutate(self):
        self.best = self.best.astype(np.int64)
        for i in range(len(self.men)):
            if self.mutatebest == True or i != self.best:
                for j in range(1, len(self.men[i]) - 2): 
                    if random.random() < self.mutationrate:
                            rand = random.randint(1, self.numberofstops - 2)
                            temp = self.men[i][j]
                            self.men[i][j] = self.men[i][rand]
                            self.men[i][rand] = temp

                        

    #start calculation
    def calculate(self, iterations): 
        best = np.array(self.getbestsalesmen())[...,0][-1]
        best = best.astype(np.int64)  
        bestlength = np.array(self.getbestsalesmen())[...,1][-1]
        for number in range(iterations):
            self.breednewgeneration() 
            self.best = np.array(self.getbestsalesmen())[...,0][-1] 
            self.mutate()
        best = np.array(self.getbestsalesmen())[...,0][-1]
        bestlength = np.array(self.getbestsalesmen())[...,1][-1]
        best = best.astype(np.int64)   
        print("최종경로 : ", self.men[best])
        print('소요 시간: ', bestlength)
        map_marker(self.men[best])

if __name__ == "__main__":  

    if city_length == 3:
        map_marker(np.array([0, 2, 1]))
    
    else:
        global halflength 
        if city_length == 6 or city_length == 5 : halflength = 2
        elif city_length == 4 : halflength = 1
        
        #initialize object
        man = salesman(1000, city_length, city_length - 1, 0.1, verbose = False, mutatebest = False)
         
        man.calculate(500)
        
