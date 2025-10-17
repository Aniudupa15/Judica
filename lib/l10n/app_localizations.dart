import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_te.dart';
import 'app_localizations_tn.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('te'),
    Locale('tn')
  ];

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, I’m Judica your Legal Assistant.'**
  String get hello;

  /// No description provided for @mymission.
  ///
  /// In en, this message translates to:
  /// **'My mission is to make sure everyone gets the support they need in the legal system. Whether you’re seeking advice, looking for guidance on bail, or need a quick understanding of legal terms, I’m here to help.'**
  String get mymission;

  /// No description provided for @getstarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getstarted;

  /// No description provided for @makinglegal.
  ///
  /// In en, this message translates to:
  /// **'Making Legal Support Legal Support Clear and Accessible.'**
  String get makinglegal;

  /// No description provided for @isimplify.
  ///
  /// In en, this message translates to:
  /// **'I simplify complex legal terms and processes, helping regular users understand their rights and options. Whether facing a legal issue or navigating the bail process, I provide clear, straightforward guidance. My goal is to ensure everyone has access to reliable legal support, regardless of who they are.'**
  String get isimplify;

  /// No description provided for @empowering.
  ///
  /// In en, this message translates to:
  /// **'Empowering Advocates with Quick, Reliable Legal Resources.'**
  String get empowering;

  /// No description provided for @iprovide.
  ///
  /// In en, this message translates to:
  /// **'I provide advocates with fast and dependable access to essential legal resources, from case references and legal precedents to procedural guidelines. My goal is to streamline your work, allowing you to focus more on effectively supporting your clients.'**
  String get iprovide;

  /// No description provided for @streamlining.
  ///
  /// In en, this message translates to:
  /// **'Streamlining FIR Filing with Accurate Legal Language. '**
  String get streamlining;

  /// No description provided for @iassist.
  ///
  /// In en, this message translates to:
  /// **'I assist police officers by transforming individual complaints into accurate legal language using NLP, identifying relevant laws and sections to simplify and expedite FIR filing. This ensures the FIR aligns with legal standards, enabling officers to respond to complaints more efficiently, even without immediate access to a legal expert.'**
  String get iassist;

  /// No description provided for @judica.
  ///
  /// In en, this message translates to:
  /// **'Judica'**
  String get judica;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmpassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmpassword;

  /// No description provided for @citizen.
  ///
  /// In en, this message translates to:
  /// **'Citizen'**
  String get citizen;

  /// No description provided for @police.
  ///
  /// In en, this message translates to:
  /// **'Police'**
  String get police;

  /// No description provided for @advocate.
  ///
  /// In en, this message translates to:
  /// **'Advocate'**
  String get advocate;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @haveanaccount.
  ///
  /// In en, this message translates to:
  /// **'Have an account'**
  String get haveanaccount;

  /// No description provided for @forgotpassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotpassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @orcontinuewith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orcontinuewith;

  /// No description provided for @donthaveaccount.
  ///
  /// In en, this message translates to:
  /// **'Dont have an account ? Signup'**
  String get donthaveaccount;

  /// No description provided for @chatbot.
  ///
  /// In en, this message translates to:
  /// **'ChatBot'**
  String get chatbot;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @mobilenumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobilenumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @notavailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notavailable;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @clicktoupload.
  ///
  /// In en, this message translates to:
  /// **'Click to upload'**
  String get clicktoupload;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @fir.
  ///
  /// In en, this message translates to:
  /// **'FIR'**
  String get fir;

  /// No description provided for @generatefir.
  ///
  /// In en, this message translates to:
  /// **'Generate FIR'**
  String get generatefir;

  /// No description provided for @viewfir.
  ///
  /// In en, this message translates to:
  /// **'View FIR'**
  String get viewfir;

  /// No description provided for @booknumber.
  ///
  /// In en, this message translates to:
  /// **'Book Number'**
  String get booknumber;

  /// No description provided for @formnumber.
  ///
  /// In en, this message translates to:
  /// **'Form Number'**
  String get formnumber;

  /// No description provided for @policestationame.
  ///
  /// In en, this message translates to:
  /// **'Police Station Name'**
  String get policestationame;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @dhoccurrence.
  ///
  /// In en, this message translates to:
  /// **'Date/Hour of Occurrence'**
  String get dhoccurrence;

  /// No description provided for @dhreported.
  ///
  /// In en, this message translates to:
  /// **'Date/Hour Reported'**
  String get dhreported;

  /// No description provided for @informername.
  ///
  /// In en, this message translates to:
  /// **'Informer Name'**
  String get informername;

  /// No description provided for @descripoffense.
  ///
  /// In en, this message translates to:
  /// **'Description of Offense'**
  String get descripoffense;

  /// No description provided for @placeofoccur.
  ///
  /// In en, this message translates to:
  /// **'Place of Occurrence'**
  String get placeofoccur;

  /// No description provided for @criminalname.
  ///
  /// In en, this message translates to:
  /// **'Criminal Name'**
  String get criminalname;

  /// No description provided for @investsteps.
  ///
  /// In en, this message translates to:
  /// **'Investigation Steps'**
  String get investsteps;

  /// No description provided for @dispatchtime.
  ///
  /// In en, this message translates to:
  /// **'Dispatch time'**
  String get dispatchtime;

  /// No description provided for @nofirsavailable.
  ///
  /// In en, this message translates to:
  /// **'No FIRs available'**
  String get nofirsavailable;

  /// No description provided for @bail.
  ///
  /// In en, this message translates to:
  /// **'Bail'**
  String get bail;

  /// No description provided for @statute.
  ///
  /// In en, this message translates to:
  /// **'Statute'**
  String get statute;

  /// No description provided for @ndps.
  ///
  /// In en, this message translates to:
  /// **'NDPS'**
  String get ndps;

  /// No description provided for @scst.
  ///
  /// In en, this message translates to:
  /// **'SCST Act'**
  String get scst;

  /// No description provided for @pmla.
  ///
  /// In en, this message translates to:
  /// **'PMLA'**
  String get pmla;

  /// No description provided for @crpc.
  ///
  /// In en, this message translates to:
  /// **'CrPC'**
  String get crpc;

  /// No description provided for @ipc.
  ///
  /// In en, this message translates to:
  /// **'IPC'**
  String get ipc;

  /// No description provided for @offensecategory.
  ///
  /// In en, this message translates to:
  /// **'Offense Category'**
  String get offensecategory;

  /// No description provided for @crimeschildren.
  ///
  /// In en, this message translates to:
  /// **'Crimes Against Children'**
  String get crimeschildren;

  /// No description provided for @offensestate.
  ///
  /// In en, this message translates to:
  /// **'Offense Against the State'**
  String get offensestate;

  /// No description provided for @crimesforeigner.
  ///
  /// In en, this message translates to:
  /// **'Crimes Against Foreginer'**
  String get crimesforeigner;

  /// No description provided for @crimesscst.
  ///
  /// In en, this message translates to:
  /// **'Crimes Against SCs and STs'**
  String get crimesscst;

  /// No description provided for @cybercrime.
  ///
  /// In en, this message translates to:
  /// **'Cyber Crime'**
  String get cybercrime;

  /// No description provided for @economicoffense.
  ///
  /// In en, this message translates to:
  /// **'Economic Offenses'**
  String get economicoffense;

  /// No description provided for @crimeswomen.
  ///
  /// In en, this message translates to:
  /// **'Crimes Against Women'**
  String get crimeswomen;

  /// No description provided for @penalty.
  ///
  /// In en, this message translates to:
  /// **'Penalty'**
  String get penalty;

  /// No description provided for @fine.
  ///
  /// In en, this message translates to:
  /// **'Fine'**
  String get fine;

  /// No description provided for @imprisonment.
  ///
  /// In en, this message translates to:
  /// **'Imprisonment'**
  String get imprisonment;

  /// No description provided for @both.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get both;

  /// No description provided for @imprisonserved.
  ///
  /// In en, this message translates to:
  /// **'Imprisonment Duration served(in years)'**
  String get imprisonserved;

  /// No description provided for @riskofescape.
  ///
  /// In en, this message translates to:
  /// **'Risk of Escape'**
  String get riskofescape;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No survey responses available.'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @riskofinfluence.
  ///
  /// In en, this message translates to:
  /// **'Risk Of Influence'**
  String get riskofinfluence;

  /// No description provided for @suretybond.
  ///
  /// In en, this message translates to:
  /// **'Surety Bond Required'**
  String get suretybond;

  /// No description provided for @personalbond.
  ///
  /// In en, this message translates to:
  /// **'Personal Bond Required'**
  String get personalbond;

  /// No description provided for @finesapplicable.
  ///
  /// In en, this message translates to:
  /// **'Fines Applicable'**
  String get finesapplicable;

  /// No description provided for @servedhalfterm.
  ///
  /// In en, this message translates to:
  /// **'Served Half Term'**
  String get servedhalfterm;

  /// No description provided for @riskscore.
  ///
  /// In en, this message translates to:
  /// **'Risk Score'**
  String get riskscore;

  /// No description provided for @penaltySeverity.
  ///
  /// In en, this message translates to:
  /// **'Penalty Severity'**
  String get penaltySeverity;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @please.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address.'**
  String get please;

  /// No description provided for @resetpassword.
  ///
  /// In en, this message translates to:
  /// **'Password reset email sent! Check your inbox.'**
  String get resetpassword;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get error;

  /// No description provided for @enteremail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enteremail;

  /// No description provided for @repassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password →'**
  String get repassword;

  /// No description provided for @cannotemail.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get cannotemail;

  /// No description provided for @cannotpasswort.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get cannotpasswort;

  /// No description provided for @usernotfound.
  ///
  /// In en, this message translates to:
  /// **'User role not found.'**
  String get usernotfound;

  /// No description provided for @pleasewait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleasewait;

  /// No description provided for @continu.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get continu;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get account;

  /// No description provided for @sign.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get sign;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'SelectLanguage'**
  String get selectLanguage;

  /// No description provided for @changessaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved successfully!'**
  String get changessaved;

  /// No description provided for @edittitle.
  ///
  /// In en, this message translates to:
  /// **'Edit \$title'**
  String get edittitle;

  /// No description provided for @enternewtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter new \$title'**
  String get enternewtitle;

  /// No description provided for @passworddont.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match!'**
  String get passworddont;

  /// No description provided for @regsuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get regsuccess;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'weak-password'**
  String get weakPassword;

  /// No description provided for @passwordtooweak.
  ///
  /// In en, this message translates to:
  /// **'The password provided is too weak.'**
  String get passwordtooweak;

  /// No description provided for @emailalreadyinuse.
  ///
  /// In en, this message translates to:
  /// **'email-already-in-use'**
  String get emailalreadyinuse;

  /// No description provided for @alreadyexist.
  ///
  /// In en, this message translates to:
  /// **'The account already exists for that email.'**
  String get alreadyexist;

  /// No description provided for @invalidemail.
  ///
  /// In en, this message translates to:
  /// **'invalid-email'**
  String get invalidemail;

  /// No description provided for @notvalid.
  ///
  /// In en, this message translates to:
  /// **'The email provided is not valid.'**
  String get notvalid;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'users'**
  String get users;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'role'**
  String get role;

  /// No description provided for @selectrole.
  ///
  /// In en, this message translates to:
  /// **'Select Role'**
  String get selectrole;

  /// No description provided for @chathistory.
  ///
  /// In en, this message translates to:
  /// **'chat_history'**
  String get chathistory;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'question'**
  String get question;

  /// No description provided for @answer.
  ///
  /// In en, this message translates to:
  /// **'answer'**
  String get answer;

  /// No description provided for @errore.
  ///
  /// In en, this message translates to:
  /// **'Error: \$e'**
  String get errore;

  /// No description provided for @askaquestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question...'**
  String get askaquestion;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @deletemsg.
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get deletemsg;

  /// No description provided for @policecommunity.
  ///
  /// In en, this message translates to:
  /// **'Police Community Engagement'**
  String get policecommunity;

  /// No description provided for @pleaseentertitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter title and questions'**
  String get pleaseentertitle;

  /// No description provided for @surveycreatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Survey created successfully'**
  String get surveycreatedsuccessfully;

  /// No description provided for @plscmpltannouncement.
  ///
  /// In en, this message translates to:
  /// **'Please complete the announcement details'**
  String get plscmpltannouncement;

  /// No description provided for @announcementcreatedsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Announcement created successfully'**
  String get announcementcreatedsuccessfully;

  /// No description provided for @survey.
  ///
  /// In en, this message translates to:
  /// **'Survey'**
  String get survey;

  /// No description provided for @anunce.
  ///
  /// In en, this message translates to:
  /// **'Announcement'**
  String get anunce;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @createsurvey.
  ///
  /// In en, this message translates to:
  /// **'Create Survey'**
  String get createsurvey;

  /// No description provided for @surveytitle.
  ///
  /// In en, this message translates to:
  /// **'Survey Title'**
  String get surveytitle;

  /// No description provided for @entersurveyquestion.
  ///
  /// In en, this message translates to:
  /// **'Enter Survey Question'**
  String get entersurveyquestion;

  /// No description provided for @entersurveyoption.
  ///
  /// In en, this message translates to:
  /// **'Enter Survey Option'**
  String get entersurveyoption;

  /// No description provided for @addoption.
  ///
  /// In en, this message translates to:
  /// **'Add Option'**
  String get addoption;

  /// No description provided for @addquestion.
  ///
  /// In en, this message translates to:
  /// **'Add Question'**
  String get addquestion;

  /// No description provided for @sub.
  ///
  /// In en, this message translates to:
  /// **'Submit Survey'**
  String get sub;

  /// No description provided for @reviewsurvey.
  ///
  /// In en, this message translates to:
  /// **'Review Survey'**
  String get reviewsurvey;

  /// No description provided for @reviewyoursurvey.
  ///
  /// In en, this message translates to:
  /// **'Review Your Survey'**
  String get reviewyoursurvey;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @submitsurvey.
  ///
  /// In en, this message translates to:
  /// **'Submit Survey'**
  String get submitsurvey;

  /// No description provided for @editsurvey.
  ///
  /// In en, this message translates to:
  /// **'Edit Survey'**
  String get editsurvey;

  /// No description provided for @showresponses.
  ///
  /// In en, this message translates to:
  /// **'Show Responses'**
  String get showresponses;

  /// No description provided for @createpublicannouncement.
  ///
  /// In en, this message translates to:
  /// **'Create Public Announcement'**
  String get createpublicannouncement;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @scheme.
  ///
  /// In en, this message translates to:
  /// **'Scheme (if applicable)'**
  String get scheme;

  /// No description provided for @instruction.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instruction;

  /// No description provided for @submitannouncement.
  ///
  /// In en, this message translates to:
  /// **'Submit Announcement'**
  String get submitannouncement;

  /// No description provided for @surveyresponses.
  ///
  /// In en, this message translates to:
  /// **'Survey Responses'**
  String get surveyresponses;

  /// No description provided for @noresponseyet.
  ///
  /// In en, this message translates to:
  /// **'No responses yet.'**
  String get noresponseyet;

  /// No description provided for @registrationlink.
  ///
  /// In en, this message translates to:
  /// **'Registration Link'**
  String get registrationlink;

  /// No description provided for @viewfirpdf.
  ///
  /// In en, this message translates to:
  /// **'View FIR PDF'**
  String get viewfirpdf;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active Complaints'**
  String get active;

  /// No description provided for @resolvedcomplaints.
  ///
  /// In en, this message translates to:
  /// **'Resolved Complaints'**
  String get resolvedcomplaints;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get all;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'Survey ID'**
  String get id;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Crimes Against Children'**
  String get children;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'Offenses Against the State'**
  String get state;

  /// No description provided for @foreigner.
  ///
  /// In en, this message translates to:
  /// **'Crimes Against Foreigners'**
  String get foreigner;

  /// No description provided for @crimeScSt.
  ///
  /// In en, this message translates to:
  /// **'Crimes Against SCs and STs'**
  String get crimeScSt;

  /// No description provided for @cyber.
  ///
  /// In en, this message translates to:
  /// **'Cyber Crime'**
  String get cyber;

  /// No description provided for @economic.
  ///
  /// In en, this message translates to:
  /// **'Economic Offense'**
  String get economic;

  /// No description provided for @women.
  ///
  /// In en, this message translates to:
  /// **'Crimes Against Women'**
  String get women;

  /// No description provided for @offense.
  ///
  /// In en, this message translates to:
  /// **'Offense Category'**
  String get offense;

  /// No description provided for @imprisonments.
  ///
  /// In en, this message translates to:
  /// **'Imprisonment Duration Served (in years)'**
  String get imprisonments;

  /// No description provided for @escape.
  ///
  /// In en, this message translates to:
  /// **'Risk of Escape'**
  String get escape;

  /// No description provided for @influencer.
  ///
  /// In en, this message translates to:
  /// **'Risk of Influence'**
  String get influencer;

  /// No description provided for @surety.
  ///
  /// In en, this message translates to:
  /// **'Surety Bond Required'**
  String get surety;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal Bond Required'**
  String get personal;

  /// No description provided for @fines.
  ///
  /// In en, this message translates to:
  /// **'Fines Applicable'**
  String get fines;

  /// No description provided for @served.
  ///
  /// In en, this message translates to:
  /// **'Served Half Term'**
  String get served;

  /// No description provided for @riskScore.
  ///
  /// In en, this message translates to:
  /// **'Risk Score'**
  String get riskScore;

  /// No description provided for @severity.
  ///
  /// In en, this message translates to:
  /// **'Penalty Severity'**
  String get severity;

  /// No description provided for @selectlabel.
  ///
  /// In en, this message translates to:
  /// **'Please select'**
  String get selectlabel;

  /// No description provided for @rror.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get rror;

  /// No description provided for @granted.
  ///
  /// In en, this message translates to:
  /// **'Bail Granted'**
  String get granted;

  /// No description provided for @denied.
  ///
  /// In en, this message translates to:
  /// **'Bail Denied'**
  String get denied;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @fyn.
  ///
  /// In en, this message translates to:
  /// **'Fine'**
  String get fyn;

  /// No description provided for @oth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get oth;

  /// No description provided for @imprison.
  ///
  /// In en, this message translates to:
  /// **'Imprisonment'**
  String get imprison;

  /// No description provided for @microphone.
  ///
  /// In en, this message translates to:
  /// **'Tap the microphone to start'**
  String get microphone;

  /// No description provided for @speech.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is not available.'**
  String get speech;

  /// No description provided for @askquestion.
  ///
  /// In en, this message translates to:
  /// **'Ask a question...'**
  String get askquestion;

  /// No description provided for @failmsg.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message.'**
  String get failmsg;

  /// No description provided for @nomsg.
  ///
  /// In en, this message translates to:
  /// **'No messages yet.'**
  String get nomsg;

  /// No description provided for @writemsg.
  ///
  /// In en, this message translates to:
  /// **'Write a message...'**
  String get writemsg;

  /// No description provided for @selectadvocate.
  ///
  /// In en, this message translates to:
  /// **'Select an Advocate'**
  String get selectadvocate;

  /// No description provided for @noadvocate.
  ///
  /// In en, this message translates to:
  /// **'No advocates available.'**
  String get noadvocate;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @cloudinary.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload file to Cloudinary.'**
  String get cloudinary;

  /// No description provided for @complaintsub.
  ///
  /// In en, this message translates to:
  /// **'Complaint submitted successfully!'**
  String get complaintsub;

  /// No description provided for @filecom.
  ///
  /// In en, this message translates to:
  /// **'File a Complaint'**
  String get filecom;

  /// No description provided for @incidentdesc.
  ///
  /// In en, this message translates to:
  /// **'Incident Description'**
  String get incidentdesc;

  /// No description provided for @providedesc.
  ///
  /// In en, this message translates to:
  /// **'Please provide a description of the incident.'**
  String get providedesc;

  /// No description provided for @prior.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get prior;

  /// No description provided for @usecurrentloc.
  ///
  /// In en, this message translates to:
  /// **'Use Current Location'**
  String get usecurrentloc;

  /// No description provided for @attach.
  ///
  /// In en, this message translates to:
  /// **'Attach Media/Document'**
  String get attach;

  /// No description provided for @submitcomp.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get submitcomp;

  /// No description provided for @governmentscheme.
  ///
  /// In en, this message translates to:
  /// **'Government Schemes & Legal Rights'**
  String get governmentscheme;

  /// No description provided for @surveys.
  ///
  /// In en, this message translates to:
  /// **'Surveys'**
  String get surveys;

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @nosurveys.
  ///
  /// In en, this message translates to:
  /// **'No surveys available.'**
  String get nosurveys;

  /// No description provided for @untitledsurvey.
  ///
  /// In en, this message translates to:
  /// **'Untitled Survey'**
  String get untitledsurvey;

  /// No description provided for @sursub.
  ///
  /// In en, this message translates to:
  /// **'Survey submitted successfully'**
  String get sursub;

  /// No description provided for @surdetails.
  ///
  /// In en, this message translates to:
  /// **'Survey Details'**
  String get surdetails;

  /// No description provided for @alreadyans.
  ///
  /// In en, this message translates to:
  /// **'You have already answered this survey.'**
  String get alreadyans;

  /// No description provided for @subsurvey.
  ///
  /// In en, this message translates to:
  /// **'Submit Survey'**
  String get subsurvey;

  /// No description provided for @noannoun.
  ///
  /// In en, this message translates to:
  /// **'No announcements available.'**
  String get noannoun;

  /// No description provided for @untitledannoun.
  ///
  /// In en, this message translates to:
  /// **'Untitled Announcement'**
  String get untitledannoun;

  /// No description provided for @announdet.
  ///
  /// In en, this message translates to:
  /// **'Announcement Details'**
  String get announdet;

  /// No description provided for @untscheme.
  ///
  /// In en, this message translates to:
  /// **'Untitled Scheme'**
  String get untscheme;

  /// No description provided for @nodescAvl.
  ///
  /// In en, this message translates to:
  /// **'Description not available.'**
  String get nodescAvl;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions:'**
  String get instructions;

  /// No description provided for @noinst.
  ///
  /// In en, this message translates to:
  /// **'No instructions available.'**
  String get noinst;

  /// No description provided for @unableopen.
  ///
  /// In en, this message translates to:
  /// **'Unable to open registration link.'**
  String get unableopen;

  /// No description provided for @regScheme.
  ///
  /// In en, this message translates to:
  /// **'Register for Scheme'**
  String get regScheme;

  /// No description provided for @nouserName.
  ///
  /// In en, this message translates to:
  /// **'User name not available.'**
  String get nouserName;

  /// No description provided for @chtbt.
  ///
  /// In en, this message translates to:
  /// **'Chatbot'**
  String get chtbt;

  /// No description provided for @prfl.
  ///
  /// In en, this message translates to:
  /// **'profile'**
  String get prfl;

  /// No description provided for @fil.
  ///
  /// In en, this message translates to:
  /// **'filing'**
  String get fil;

  /// No description provided for @cht.
  ///
  /// In en, this message translates to:
  /// **'chat'**
  String get cht;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'en',
        'hi',
        'kn',
        'ml',
        'te',
        'tn'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'te':
      return AppLocalizationsTe();
    case 'tn':
      return AppLocalizationsTn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
