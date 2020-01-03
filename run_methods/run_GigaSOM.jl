#=
Julia script to run GigaSOM. This script is based on L.Weber: run_FlowSOM

Oliver Hunewald, January 2020
=#

using GigaSOM, DataFrames, XLSX, CSV, Test, Random, Distributed, SHA

checkDir()
#create genData and data folder and change dir to dataPath
cwd = pwd()

datapath = "/Users/ohunewald/work/GigaSOM_data/validation_results/Weber_cytof_comparison"

cd(datapath)

data = Dict("Levine_32dim.fcs" => [5:36;],
            "Levine_13dim.fcs" => [1:13;],
            "Samusik_01.fcs" => [9:47;],
            "Samusik_all.fcs" => [9:47;],
            "Nilsson_rare.fcs" => [5:7; 9:18],
            "Mosmann_rare.fcs" => [7:9; 11:21])

# for (k,v) in data
#     println(k)
# end


fcsRaw = readFlowFrame("Levine_32dim.fcs")
cleanNames!(fcsRaw)

daf = fcsRaw["Levine_32dim.fcs"]
daf_sub = daf[:, 5:36]
p = addprocs(2)

@everywhere using GigaSOM

som2 = initGigaSOM(daf_sub, 10, 10)
@time som2 = trainGigaSOM(som2, daf_sub, epochs = 10)
winners = mapToGigaSOM(som2, daf_sub)
CSV.write("clustering_Levine_32dim_GigaSOM.csv", winners)


rmprocs(workers())

# extract the codes for consensus clustering
codes = som2.codes

try
	using RCall
catch
	using Pkg
	Pkg.add("RCall")
end
using RCall
using Statistics
using LinearAlgebra
Pkg.add("StatsBase")
using StatsBase
@rlibrary consens2

plot_outdir = "consensus_plots"
nmc = 40
codesT = Matrix(codes')

mc = ConsensusClusterPlus_2(codesT, maxK = nmc, reps = 100,
							pItem = 0.9, pFeature = 1,
							clusterAlg = "hc", innerLinkage = "average", finalLinkage = "average",
							distance = "euclidean", seed = 1234)

cell_clustering = mc[winners.index]
# cell_clustering = convert(DataFrame, cell_clustering')
cc = DataFrame(id = cell_clustering)
CSV.write("clustering_Levine_32dim_GigaSOM_40_metaCluster.csv", cc)

println("Hello World!")