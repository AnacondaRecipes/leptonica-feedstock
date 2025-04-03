:: cmd
set PATH=%PATH%;%CD%

echo "Building %PKG_NAME%."


:: Isolate the build.
mkdir Build-%PKG_NAME%
cd Build-%PKG_NAME%
if errorlevel 1 exit /b 1

:: Generate the build files.
echo "Generating the build files..."
cmake .. %CMAKE_ARGS% ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DBUILD_PROG=1 ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INCLUDE_PATH=%LIBRARY_INC% ^
      -DCMAKE_LIBRARY_PATH=%LIBRARY_LIB% ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DBUILD_SHARED_LIBS=ON ^
      -DCMAKE_MODULE_LINKER_FLAGS=-whole-archive ^
      -DSW_BUILD=OFF ^
      -G "NMake Makefiles" ^
      ..
if errorlevel 1 exit 1

cmake --build . --config Release
if errorlevel 1 exit 1

cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: Make copies of the .lib file without the embedded version number
copy %LIBRARY_LIB%\leptonica-%PKG_VERSION%.lib %LIBRARY_LIB%\leptonica.lib
copy %LIBRARY_LIB%\leptonica-%PKG_VERSION%.lib %LIBRARY_LIB%\lept.lib

:: Error free exit.
echo "Error free exit!"
exit 0