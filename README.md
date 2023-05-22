
AI Translate uses the DeepL Translator API to translate text into 31 languages.

The API request needs three parameters: "text", "source" and "target".

The "text" parameter refers to the text to be translated.
This is filled in by what the user types in a UITextView.
The initial version of the app used UITextFields but these have been replaced to allow the user to type 
multiline text instead.

The "source" and "target" parameters , referring respectively to the language of the original 
and final text, are filled in via two UIPickerViews.
As the API requires specific languages codes to be passed, a switch statement has been used to link each 
language to the code specified in the API documentation.







