close all; clear all;clc;
rootdir = 'H:\Ilana';
cd(rootdir)
List = dir('*.csv');


for k = 1:length(List)
    [Path,Name,Type] = fileparts([rootdir '/' List(k).name]);
    Filenames{k,1} = [Path '/' Name Type];
    Filenames{k,2} = Path;
    Filenames{k,3} = [Name Type];
    Filenames{k,4} = Name(1:4);
end
clear k

for k = 1:length(List)
    data = readtable(List(k).name);
    Alldata(k).raw = data;
    clear data
end

for i = 1:length(Alldata)
    x = Alldata(i).raw;
    names{i}.n = x.Properties.VariableNames;
    clear x
end
list = {'Date'};
for i = 1:length(names)
    x = strmatch(list, names{i}.n);
    Alldata(i).index = x;
    clear x
end

for i = 1:length(Alldata)
    dat = Alldata(i).raw;
    for j = 1:length(Alldata(i).index)
        Animal(j).data = dat(:,Alldata(i).index(j):Alldata(i).index(j)+2);
    end
    Alldata(i).animaldata = Animal;
    clear Animal
end
clear dat i j k list names

for i = 1:length(Alldata)
    for j = 1:length(Alldata(i).animaldata)
        Alldata(i).animaldata(j).data.Properties.VariableNames{1} = 'Date';
        Alldata(i).animaldata(j).data.Properties.VariableNames{3} = 'Temp';
    end
end

for i = 1:length(Alldata)
    for j = 1:length(Alldata(i).animaldata)
        Dates = Alldata(i).animaldata(j).data.Date;
        Data = Alldata(i).animaldata(j).data.Temp;
        date_x = unique(Dates);
        for k = 1:length(date_x)
            date_index = find(Dates == date_x(k));
            Data_by_date = Data(date_index,:);
            By_date(k).data = Data_by_date;
            clear date_index Data_by_date
        end
    Alldata(i).animaldata(j).date_data = By_date;
    clear By_date date_x Data
    end
end
clear i j k 
%Quantify

for i = 1:length(Alldata)
    for j = 1:length(Alldata(i).animaldata)
        for k = 1:length(Alldata(i).animaldata(j).date_data)
            x = Alldata(i).animaldata(j).date_data(k).data;
            [Alldata(i).animaldata(j).date_data(k).max_temp Alldata(i).animaldata(j).date_data(k).index_max] = max(x);
            [Alldata(i).animaldata(j).date_data(k).min_temp Alldata(i).animaldata(j).date_data(k).index_min] = min(x);
            Alldata(i).animaldata(j).date_data(k).delta_temp =  Alldata(i).animaldata(j).date_data(k).max_temp - Alldata(i).animaldata(j).date_data(k).min_temp;
            Alldata(i).animaldata(j).date_data(k).mean_temp = mean(x);
        end
    end
end

save('Alldata.mat', 'Alldata')
            
            

    
%     