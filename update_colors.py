import re

html_path = "c:/Users/sebas/Documents/pagina wep/candidatos.html"
with open(html_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

count = 0
out_lines = []
for line in lines:
    if 'class="candidato-puesto text-' in line:
        color = "celeste" if (count % 4) < 2 else "verde"
        line = re.sub(r'text-(celeste|verde)', f'text-{color}', line)
        count += 1
    out_lines.append(line)

with open(html_path, "w", encoding="utf-8") as f:
    f.writelines(out_lines)

