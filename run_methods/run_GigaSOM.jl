#=
Julia script to run GigaSOM

Oliver Hunewald, January 2020
=#

using GigaSOM, DataFrames, XLSX, CSV, Test, Random, Distributed, SHA

checkDir()
#create genData and data folder and change dir to dataPath
cwd = pwd()

datapath = "../../"

println("Hello World!")