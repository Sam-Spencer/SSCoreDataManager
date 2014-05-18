## Contributing
This document lays out exactly how you can contribute to SSCoreDataManager. Thanks for contributing!

### How to Contribute - Issues
Found something that needs to be improved or fixed? Here's the best way to let everyone know about issues, bugs, possible new features, or just ask questions.

1. Sign up for a GitHub Account  
2. Star this repository (so you can follow changes and find it easily)  
3. Look through the [issues](https://github.com/Sam-Spencer/SSCoreDataManager/issues) (opened or closed) for SSCoreDataManager to see if your issue has already been fixed, answered, or is being fixed  
4. Create a [new issue](https://github.com/Sam-Spencer/SSCoreDataManager/issues/new) from the issues tab on the right side of the screen

### How to Contribute - Changes
Want to make a change to this project? Maybe you have a great idea, a new feature, bug fix, or something else. Here's the best way to contribute changes to the project.

1. Sign up for a GitHub Account  
2. Star this repository (so you can follow changes and find it easily)  
3. Fork this repository and clone your fork onto your computer  
4. Make changes to the forked repo (you'll probably want to change the `CoreDataManager.m` and `CoreDataManager.h` files)  
5. Build the files, fix any errors, debug, test debug some more, build again  
8. Commit and then push all your changes up to your forked GitHub repo
9. Submit a pull request from your forked GitHub repo into the main repo. Your pull request will then be reviewed and possibly accepted if everything looks good

#### Code Guidelines
Before submitting any code changes, read over the code / syntax guidelines to make sure everything you write matches the appropriate coding style. The [Objective-C Coding Guidelines](https://github.com/github/objective-c-conventions) are available on GitHub.

#### Data Model Guidelines
If you need to change the data model for the sample app, make sure to be thourough. Test the app a few times to ensure that it will not crash and that there are no issues. Changes to the data model can cause issues. If you do change the data model, please note this in your commit description and pull request.

#### Documentation Guidelines
Before submitting any changes, make sure that you've documented those changes. 

Make the appropriate updates in the Readme.md file and write appropriate documentation in the code (using comments). You can use documentation comments to create and modify documentation. Always write the documentation comments in the header, above the related method, property, etc. Write regular comments with your code in the implementation too. Here's an example of a documentation comment:

    /// One line documentation comments can use the triple forward slash. Even add \b bold text or \i italics.
    @property (nonatomic, strong) NSObject *object;

    /** Multi-line documentation comments can use the forward slash with a double asterisk at the beginning and a single asterisk at the end.
        @description Use different keys inside of a multi-line documentation comment to specify various aspects of a method. There are many available keys that Xcode recognizes: @description, @param, @return, @deprecated, @warning, etc. The documentation system also recognizes standard markdown formatting within comments. When building the documentation, this information will be appropriately formatted in Xcode and the Document Browser.

        @param parameterName Parameter Description. The @param key should be used for each parameter in a method. Make sure to describe exactly what the parameter does and if it can be nil or not.
        @return Return value. Use the @return key to specify a return value of a method. */
    - (BOOL)alwaysWriteDocumentCommentsAboveMethods:(NSObject *)paramName;

## What to Contribute
Contribute anything, I'm open to ideas! Although if you're looking for a little more structure, you can go through the [open issues on GitHub](https://github.com/Sam-Spencer/SSCoreDataManager/issues?status=open) or look at the known issues in the [Releases documentation](https://github.com/Sam-Spencer/SSCoreDataManager/releases). And if you're feeling adventurous, I'm still working on adding / testing OS X Compatibility (wink wink, nudge nudge).