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
      -G"Ninja" ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DBUILD_PROG=1 ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INCLUDE_PATH=%LIBRARY_INC% ^
      -DCMAKE_LIBRARY_PATH=%LIBRARY_LIB% ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      -DSW_BUILD=OFF ^
      ..
if errorlevel 1 exit 1

:: Build.
echo "Building..."
ninja
if errorlevel 1 exit /b 1

:: Install.
echo "Installing..."
ninja install
if errorlevel 1 exit /b 1

:: Make copies of the .lib file without the embedded version number
copy %LIBRARY_LIB%\leptonica-1.82.0.lib %LIBRARY_LIB%\leptonica.lib
copy %LIBRARY_LIB%\leptonica-1.82.0.lib %LIBRARY_LIB%\lept.lib

:: Error free exit.
echo "Error free exit!"
exit 0