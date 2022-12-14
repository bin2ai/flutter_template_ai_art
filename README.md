# flutter_template_ai_art

Example Flutter project for AI Art

## Getting Started

- setup your flutter environment
- setup your firebase environment

### Generate Firebase Config Files

Most of the files expose IDs and keys that may not necessarily be sensitive. However, it would be best practice to hide these files in a public repository since they are only specific to unique firebase-linked projects.

#### Fluterfire CLI configuration

.gitignore ignores the following files...

All Devices:

- /lib/firebase_options.dart

Specific Devices:

- /macos/Runner/GoogleService-Info.plist
- /macos/firebase_app_id_file.json
- /ios/Runner/GoogleService-Info.plist
- /ios/firebase_app_id_file.json
- /android/app/google-services.json

use the FlutterFire CLI to generate it

```bash
cd [project directory]
flutterfire configure
```

#### Custom Shell Script for Web

For web applications only.

.gitignore also ignores the 'google_signin_html_tag.txt' which holds the google signin client id html meta tag that is used in /web/index.html.  A custom script is used to generate the meta tag (only tested using windows powershell). The script agruments are 'hidden' or 'exposed'.  I recommend using 'hidden' for public commits and 'exposed' for local testing.  If 'exposed', the script will automatically replace the html meta tag with one in the private file. If 'hidden', the script will add a template html meta tag and the signin feature will not work.

```powershell
cd [project directory]
google_signin_html_tag.sh hidden
```

The 'google_signin_html_tag.txt' file has this format.  The script is not smart! keep everything on one line, include the single quotes, and the space between the name and content attributes, and the 2 leading spaces before the tag. Replace YOUR_CLIENT_ID with the client id from your firebase project.

```text
  <meta name='google-signin-client_id' content='YOUR_CLIENT_ID.apps.googleusercontent.com'>
```
