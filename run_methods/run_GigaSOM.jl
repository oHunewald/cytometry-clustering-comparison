#=
Julia script to run GigaSOM. This script is based on L.Weber: run_FlowSOM

Oliver Hunewald, January 2020
=#

using GigaSOM, DataFrames, XLSX, CSV, Test, Random, Distributed, SHA

checkDir()
#create genData and data folder and change dir to dataPath
cwd = pwd()

datapath = "../../"

cd(datapath)

data = Dict("Levine_32dim.fcs" => [5:36;],
            "Levine_13dim.fcs" => [1:13;],
            "Samusik_01.fcs" => [9:47;],
            "Samusik_all.fcs" => [9:47;],
            "Nilsson_rare" => [5:7; 9:18],
            "Mosmann_rare.fcs" => [7:9; 11:21])


println("Hello World!")