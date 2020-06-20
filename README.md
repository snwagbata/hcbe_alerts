## Safeskul

## Warning

Do not Manually change user's school in database without unsuscribing and resuscribing them to
from their current school.
Not following the instructions above will lead to user receiving wrong notifications which could impact 
user's ability to actively respond to alerts.

A user is suscribed to notifications from their school when they sign in to the app hence the increased time when the
login() function is called in the siginUI.
User is unsuscribed from notifications when they sign out from their accounts.
Currently there is no workaround to speed up signin time as the provider package will throw an error when a provided object is accessed in the signinUI


## **Overview of project**

**main.dart**— contains provider info for maintaining the state of the app for the theme and user. It initializes theme settings. Sets up routing and monitors the user for changes.

## **/constants/**

**app_themes.dart**— contains info related to our light and dark themes.

**routes.dart**— contains the app routes.

## /helpers/

**validator.dart**— contains some validation functions for our form fields.

## /models/

**user_model.dart**— contains the model for our user saved in firestore.

## /services/

**auth_widget_builder.dart** - holds our provider user data and initializes the user in the app.

**auth_service.dart** — our user and authentication functions for creating, logging in and out our user and saving our user data.

**theme_provider.dart**— saves and loads our theme.

## /store/

**shared_preferences_helper.dart**— saves our theme and locally.

## /ui/

**home_ui.dart** — contains the ui for the defualt screen for non admin user.

**settings_ui.dart** — contains the settings screen for setting the theme and language and some user settings.

## /ui/auth/

**reset_password_ui.dart**— sends a password reset email to the user.

**sign_in_ui.dart**— allows user to login with email and password.

**sign_up_ui.dart**— allows user to create a new account.

**update_profile_ui.dart**— allows user to change his email or name.

## /ui/components/

**avatar.dart** — displays a user avatar on the ui.

**label_button.dart** — one type of button in ui.

**logo_graphic_header.dart**— a graphic displayed in our ui.

**primary_button.dart** — another button in the ui.