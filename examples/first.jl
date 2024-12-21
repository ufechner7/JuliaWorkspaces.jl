using JuliaWorkspaces

pkg_root = abspath(joinpath(@__DIR__, "data", "TestPackage1"))

jw = workspace_from_folders([pkg_root])