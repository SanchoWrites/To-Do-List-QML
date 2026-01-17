cmake_minimum_required(VERSION 3.19)

project(QT_to_do_list VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appQT_to_do_list
    main.cpp
    windows_icon.rc
)

qt_add_qml_module(appQT_to_do_list
    URI "QT_to_do_list"
    VERSION 1.0
    QML_FILES
        Main.qml
    RESOURCES
        images/trash.png
        images/notepad.png
        images/nine_dots.png
        images/cross.svg
        images/checkmark.svg
    SOURCES
        taskmodel.h
        taskmodel.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQT_to_do_list PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQT_to_do_list
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appQT_to_do_list
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appQT_to_do_list
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
