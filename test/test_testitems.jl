@testitem "@testitem macro missing all args" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("Your @testitem is missing a name and code block.", 1:9)
end

@testitem "Wrong type for name" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem :foo
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("Your @testitem must have a first argument that is of type String for the name.", 1:14)
end

@testitem "Code block missing" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem "foo"
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("Your @testitem is missing a code block argument.", 1:15)
end

@testitem "Final arg not a code block" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem "foo" 3
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("The final argument of a @testitem must be a begin end block.", 1:17)
end

@testitem "None kw arg" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem "foo" bar begin end
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("The arguments to a @testitem must be in keyword format.", 1:29)
end

@testitem "Duplicate kw arg" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem "foo" default_imports=true default_imports=false begin end
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("The keyword argument default_imports cannot be specified more than once.", 1:68)
end

@testitem "Incomplete kw arg" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem "foo" default_imports= begin end
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("The final argument of a @testitem must be a begin end block.", 1:42)
end

@testitem "Wrong default_imports type kw arg" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem "foo" default_imports=4 begin end
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("The keyword argument default_imports only accepts bool values.", 1:43)
end

@testitem "non vector arg for tags kw" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem "foo" tags=4 begin end
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("The keyword argument tags only accepts a vector of symbols.", 1:32)
end

@testitem "Wrong types in tags kw arg" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem "foo" tags=[4, 8] begin end
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("The keyword argument tags only accepts a vector of symbols.", 1:37)
end

@testitem "Unknown keyword arg" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem "foo" bar=true begin end
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("Unknown keyword argument.", 1:34)
end

@testitem "All parts correctly there" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestItemDetail
    using JuliaWorkspaces.URIs2: @uri_str

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", """@testitem "foo" tags=[:a, :b] setup=[FooSetup] default_imports=true begin println() end
    """)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 1
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 0

    ti = jw._testitems[uri"file://src/foo.jl"][1]

    @test ti.name == "foo"
    @test ti.project_uri == nothing
    @test ti.package_uri == nothing
    @test ti.package_name == ""
    @test ti.range == 1:87
    @test ti.code_range == 75:83
    @test ti.option_default_imports == true
    @test ti.option_tags == [:a, :b]
    @test ti.option_setup == [:FooSetup]
end

@testitem "@testsetup macro missing module arg" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    src = """@testsetup
    """

    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", src)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("Your `@testsetup` is missing a `module ... end` block.", 1:length(src)-1)
end

@testitem "@testsetup macro extra args" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestErrorDetail
    using JuliaWorkspaces.URIs2: @uri_str

    src = """@testsetup "Foo" module end"""
    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", src)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 0
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 1

    @test jw._testerrors[uri"file://src/foo.jl"][1] == TestErrorDetail("Your `@testsetup` must have a single `module ... end` argument.", 1:length(src))
end

@testitem "@testsetup all correct" begin
    using JuliaWorkspaces: JuliaWorkspace, add_file, TestSetupDetail
    using JuliaWorkspaces.URIs2: @uri_str

    src = """@testsetup module Foo
        const BAR = 1
        qux() = 2
    end
    """
    jw = add_file(JuliaWorkspace([uri"file://src"]), uri"file://src/foo.jl", src)

    @test length(jw._testitems[uri"file://src/foo.jl"]) == 0
    @test length(jw._testsetups[uri"file://src/foo.jl"]) == 1
    @test length(jw._testerrors[uri"file://src/foo.jl"]) == 0

    tsd = jw._testsetups[uri"file://src/foo.jl"][1]

    @test tsd.name == :Foo
    @test tsd.range == 1:length(src)-1
    @test tsd.code_range == (length("@testsetup module Foo") + 1):(length(src) - 4)
end
