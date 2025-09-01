workspace "Hazel"
    architecture "x64"
    
    configurations
    {
        "Debug",
        "Release",
        "Dist"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "Hazel"
    location "Hazel"
    kind "SharedLib"
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/**.h",
        "%{prj.name}/**.cpp",
    }
    removefiles { "Hazel/vendor/**.cpp", "Hazel/vendor/**.c" }

    includedirs
    {
        "%{prj.name}",
        "%{prj.name}/vendor/spdlog/include"
    }

    filter "system:windows"
        buildoptions { "/utf-8" }
        cppdialect "C++17"
        staticruntime "On"

        systemversion "latest"
        
        defines
        {
            "HZ_PLATFORM_WINDOWS",
            "HZ_BUILD_DLL"
        }

        postbuildcommands
        {
            ("{COPYFILE} %{cfg.buildtarget.relpath} ../bin/"  .. outputdir .. "/Sandbox")

        }
    
    filter "configurations:Debug"
        defines "HZ_DEBUG"
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        optimize "On"

    filter "configurations:Dist"
        defines "HZ_DIST"
        optimize "On"


project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/**.h",
        "%{prj.name}/**.cpp",
    }

    includedirs
    {
        "$(SolutionDir)Hazel/vendor/spdlog/include",
        "$(SolutionDir)Hazel"
    }


    links
    {
        "Hazel"
    }

    filter "system:windows"
        buildoptions { "/utf-8" }
        cppdialect "C++17"
        staticruntime "On"
        systemversion "latest"
        
        defines
        {
            "HZ_PLATFORM_WINDOWS",
        }

    filter "configurations:Debug"
        defines "HZ_DEBUG"
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        optimize "On"

    filter "configurations:Dist"
        defines "HZ_DIST"
        optimize "On"