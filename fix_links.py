import os

files = ['CronogramaLector.html', 'recursoscl.html']
old_text = 'docs.google.com/spreadsheets/d/'
new_text = 'docs.google.com/spreadsheets/u/0/d/'

for filename in files:
    if os.path.exists(filename):
        with open(filename, 'r', encoding='utf-8') as f:
            content = f.read()
        if old_text in content:
            new_content = content.replace(old_text, new_text)
            with open(filename, 'w', encoding='utf-8') as f:
                f.write(new_content)
            print(f"Fixed {filename}")
        else:
            print(f"No changes for {filename}")
