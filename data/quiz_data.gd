# quiz_data.gd
extends Resource
class_name QuizData

const TYPE_MULTI = "multi"
const TYPE_SINGLE = "single"
const TYPE_TEXT = "text"

# Structura: Cheia este ID-ul nivelului, Valoarea este Array-ul de întrebări
var chapters = {
	1: [ # Capitolul 1: Limite și vecini (10 întrebări)
		{
			"id": "c1_q1",
			"type": TYPE_SINGLE,
			"text": "Cu ce țară se învecinează România la Sud?",
			"options": ["Ungaria", "Bulgaria", "Ucraina", "Serbia"],
			"correct_index": 1
		},
		{
			"id": "c1_q2",
			"type": TYPE_MULTI,
			"text": "Care dintre următoarele sunt vecini ai României?",
			"options": ["Bulgaria", "Grecia", "Ungaria", "Polonia"],
			"correct_indices": [0, 2]
		},
		{
			"id": "c1_q3",
			"type": TYPE_SINGLE,
			"text": "Granița naturală a României în partea de Sud este formată de:",
			"options": ["Râul Prut", "Fluviul Dunărea", "Râul Tisa", "Marea Neagră"],
			"correct_index": 1
		},
		{
			"id": "c1_q4",
			"type": TYPE_SINGLE,
			"text": "În ce parte a Europei este așezată România?",
			"options": ["Nord", "Vest", "Sud-Est", "Sud-Vest"],
			"correct_index": 2
		},
		{
			"id": "c1_q5",
			"type": TYPE_TEXT,
			"text": "Râul care formează granița de est cu Republica Moldova este ______.",
			"correct_answer": "Prut"
		},
		{
			"id": "c1_q6",
			"type": TYPE_SINGLE,
			"text": "Cu ce țară se învecinează România la Nord?",
			"options": ["Bulgaria", "Ucraina", "Serbia", "Turcia"],
			"correct_index": 1
		},
		{
			"id": "c1_q7",
			"type": TYPE_SINGLE,
			"text": "Cu ce țară se învecinează România la Sud-Vest?",
			"options": ["Ungaria", "Serbia", "Ucraina", "Moldova"],
			"correct_index": 1
		},
		{
			"id": "c1_q8",
			"type": TYPE_MULTI,
			"text": "Selectează țările cu care România are graniță terestră:",
			"options": ["Ungaria", "Franța", "Ucraina", "Italia"],
			"correct_indices": [0, 2]
		},
		{
			"id": "c1_q9",
			"type": TYPE_SINGLE,
			"text": "Marea Neagră se află în partea de ... a României.",
			"options": ["Nord-Est", "Sud-Est", "Sud-Vest", "Nord-Vest"],
			"correct_index": 1
		},
		{
			"id": "c1_q10",
			"type": TYPE_TEXT,
			"text": "Capitala țării noastre este la ______.",
			"correct_answer": "București"
		}
	],
	
	2: [ # Capitolul 2: Relieful (10 întrebări)
		{
			"id": "c2_q1",
			"type": TYPE_SINGLE,
			"text": "Care este cel mai înalt vârf din România?",
			"options": ["Vârful Omu", "Vârful Moldoveanu", "Vârful Negoiu", "Vârful Parângu Mare"],
			"correct_index": 1
		},
		{
			"id": "c2_q2",
			"type": TYPE_SINGLE,
			"text": "Ce formă de relief se află în centrul țării și este numită 'cetatea de piatră' a României?",
			"options": ["Câmpia Română", "Delta Dunării", "Munții Carpați", "Podișul Dobrogei"],
			"correct_index": 2
		},
		{
			"id": "c2_q3",
			"type": TYPE_MULTI,
			"text": "Ce lanțuri muntoase fac parte din Carpați?",
			"options": ["Carpații Orientali", "Carpații Meridionali", "Carpații Occidentali", "Munții Alpi"],
			"correct_indices": [0, 1, 2]
		},
		{
			"id": "c2_q4",
			"type": TYPE_TEXT,
			"text": "Munții Carpați s-au format prin încrețirea scoarței ______.",
			"correct_answer": "Terestre"
		},
		{
			"id": "c2_q5",
			"type": TYPE_SINGLE,
			"text": "Cea mai joasă și nouă formă de relief din România este:",
			"options": ["Câmpia de Vest", "Delta Dunării", "Podișul Moldovei", "Subcarpații"],
			"correct_index": 1
		},
		{
			"id": "c2_q6",
			"type": TYPE_SINGLE,
			"text": "Forma de relief plată, situată la mică altitudine, se numește:",
			"options": ["Munte", "Deal", "Câmpie", "Podiș"],
			"correct_index": 2
		},
		{
			"id": "c2_q7",
			"type": TYPE_MULTI,
			"text": "Care dintre următoarele sunt caracteristici ale munților?",
			"options": ["Au altitudini mari", "Sunt netezi ca o masă", "Au versanți abrupți", "Sunt buni pentru agricultură intensivă"],
			"correct_indices": [0, 2]
		},
		{
			"id": "c2_q8",
			"type": TYPE_SINGLE,
			"text": "Unitatea de relief situată în interiorul arcului Carpatic este:",
			"options": ["Depresiunea Colinară a Transilvaniei", "Câmpia Română", "Podișul Moldovei", "Subcarpații"],
			"correct_index": 0
		},
		{
			"id": "c2_q9",
			"type": TYPE_SINGLE,
			"text": "Zona de relief unde se cultivă cel mai bine cerealele este:",
			"options": ["Muntele", "Câmpia", "Delta", "Dealul"],
			"correct_index": 1
		},
		{
			"id": "c2_q10",
			"type": TYPE_TEXT,
			"text": "Forma de relief intermediară între munte și câmpie se numește ______.",
			"correct_answer": "Deal"
		}
	],
	
	3: [ # Capitolul 3: Clima, apele, vegetatia, animalele si solurile (14 întrebări)
		{
			"id": "c3_q1",
			"type": TYPE_SINGLE,
			"text": "Care este principalul colector al apelor curgătoare de pe teritoriul României?",
			"options": ["Râul Olt", "Fluviul Dunărea", "Râul Mureș", "Râul Siret"],
			"correct_index": 1
		},
		{
			"id": "c3_q2",
			"type": TYPE_SINGLE,
			"text": "Ce lungime are fluviul Dunărea pe teritoriul României?",
			"options": ["2.860 km", "1.075 km", "500 km", "800 km"],
			"correct_index": 1
		},
		{
			"id": "c3_q3",
			"type": TYPE_MULTI,
			"text": "Care dintre următoarele sunt brațe ale Dunării în Deltă?",
			"options": ["Chilia", "Olt", "Sulina", "Mureș"],
			"correct_indices": [0, 2]
		},
		{
			"id": "c3_q4",
			"type": TYPE_SINGLE,
			"text": "Care este cea mai mare apă stătătoare de pe teritoriul țării noastre?",
			"options": ["Lacul Razim", "Lacul Vidraru", "Marea Neagră", "Lacul Sfânta Ana"],
			"correct_index": 2
		},
		{
			"id": "c3_q5",
			"type": TYPE_MULTI,
			"text": "Ce râuri din România se varsă în Dunăre?",
			"options": ["Siret", "Olt", "Prut", "Amazon"],
			"correct_indices": [0, 1, 2]
		},
		{
			"id": "c3_q6",
			"type": TYPE_TEXT,
			"text": "Locul de unde izvorăște un râu se numește ______.",
			"correct_answer": "Izvor"
		},
		{
			"id": "c3_q7",
			"type": TYPE_SINGLE,
			"text": "Ce tip de vegetație este specific zonelor de câmpie cu precipitații mai reduse?",
			"options": ["Pădurea de conifere", "Stepa", "Pădurea de foioase", "Vegetația alpină"],
			"correct_index": 1
		},
		{
			"id": "c3_q8",
			"type": TYPE_SINGLE,
			"text": "La ce etaj de vegetație întâlnim ursul brun și cerbul?",
			"options": ["În zona de stepă", "În zona pădurilor (foioase și conifere)", "În Delta Dunării", "Pe litoral"],
			"correct_index": 1
		},
		{
			"id": "c3_q9",
			"type": TYPE_MULTI,
			"text": "Care dintre următoarele animale trăiesc în zona de munte?",
			"options": ["Capra neagră", "Ursul brun", "Pelicanul", "Sturionul"],
			"correct_indices": [0, 1]
		},
		{
			"id": "c3_q10",
			"type": TYPE_SINGLE,
			"text": "Cum sunt solurile în zonele de câmpie, unde se dezvoltă vegetația de stepă?",
			"options": ["Foarte fertile (cernoziomuri)", "Stâncoase", "Înghețate", "Nisipoase și sărace"],
			"correct_index": 0
		},
		{
			"id": "c3_q11",
			"type": TYPE_MULTI,
			"text": "Care dintre următoarele sunt lacuri naturale?",
			"options": ["Lacul Sfânta Ana", "Lacul Vidraru", "Lacul Roșu", "Lacul Bâlea"],
			"correct_indices": [0, 2, 3]
		},
		{
			"id": "c3_q12",
			"type": TYPE_TEXT,
			"text": "Pădurile care își pierd frunzele toamna sunt păduri de ______.",
			"correct_answer": "Foioase"
		},
		{
			"id": "c3_q13",
			"type": TYPE_SINGLE,
			"text": "În ce localitate intră Dunărea pe teritoriul României?",
			"options": ["Baziaș", "Sulina", "Galați", "Drobeta-Turnu Severin"],
			"correct_index": 0
		},
		{
			"id": "c3_q14",
			"type": TYPE_MULTI,
			"text": "Ce elemente compun un râu?",
			"options": ["Izvorul", "Cursul", "Gura de vărsare", "Litoralul"],
			"correct_indices": [0, 1, 2]
		}
	],
	
	4: [ # Capitolul 4: Locuitorii si asezarile omenesti (10 întrebări)
		{
			"id": "c4_q1",
			"type": TYPE_SINGLE,
			"text": "Care este capitala României?",
			"options": ["Cluj-Napoca", "Iași", "București", "Timișoara"],
			"correct_index": 2
		},
		{
			"id": "c4_q2",
			"type": TYPE_SINGLE,
			"text": "Ce reprezintă densitatea populației?",
			"options": ["Numărul total de locuitori", "Numărul de locuitori pe un km pătrat", "Numărul de orașe", "Numărul de copii"],
			"correct_index": 1
		},
		{
			"id": "c4_q3",
			"type": TYPE_SINGLE,
			"text": "Care este forma de așezare umană unde majoritatea locuitorilor lucrează în agricultură?",
			"options": ["Orașul", "Municipiul", "Satul", "Capitala"],
			"correct_index": 2
		},
		{
			"id": "c4_q4",
			"type": TYPE_MULTI,
			"text": "Care sunt caracteristicile așezărilor rurale (sate)?",
			"options": ["Au mai puțini locuitori ca orașele", "Ocupația principală este agricultura", "Au blocuri turn", "Păstrează tradițiile"],
			"correct_indices": [0, 1, 3]
		},
		{
			"id": "c4_q5",
			"type": TYPE_TEXT,
			"text": "Așezările umane urbane se numesc ______.",
			"correct_answer": "Orașe"
		},
		{
			"id": "c4_q6",
			"type": TYPE_TEXT,
			"text": "Totalitatea locuitorilor de pe un anumit teritoriu formează ______.",
			"correct_answer": "Populația"
		},
		{
			"id": "c4_q7",
			"type": TYPE_MULTI,
			"text": "Ce factori influențează răspândirea populației?",
			"options": ["Relieful", "Clima", "Culoarea solului", "Prezența apelor"],
			"correct_indices": [0, 1, 3]
		},
		{
			"id": "c4_q8",
			"type": TYPE_SINGLE,
			"text": "Cel mai mare oraș port maritim al României este:",
			"options": ["Tulcea", "Constanța", "Mangalia", "Sulian"],
			"correct_index": 1
		},
		{
			"id": "c4_q9",
			"type": TYPE_SINGLE,
			"text": "O așezare urbană foarte mare și importantă se numește:",
			"options": ["Comună", "Sat", "Municipiu", "Cătun"],
			"correct_index": 2
		},
		{
			"id": "c4_q10",
			"type": TYPE_SINGLE,
			"text": "În ce zonă de relief densitatea populației este cea mai mică?",
			"options": ["La câmpie", "La munte", "La deal", "În orașe"],
			"correct_index": 1
		}
	],
	
	5: [ # Capitolul 5: Activitati economice (14 întrebări)
		{
			"id": "c5_q1",
			"type": TYPE_MULTI,
			"text": "Ce resurse se extrag din subsolul României?",
			"options": ["Gazele naturale", "Sarea", "Lemnul", "Cărbunii"],
			"correct_indices": [0, 1, 3]
		},
		{
			"id": "c5_q2",
			"type": TYPE_SINGLE,
			"text": "Care dintre următoarele este o resursă a subsolului?",
			"options": ["Pădurile", "Apele curgătoare", "Cărbunii", "Solurile fertile"],
			"correct_index": 2
		},
		{
			"id": "c5_q3",
			"type": TYPE_SINGLE,
			"text": "Ce ramură industrială se ocupă cu producerea curentului electric?",
			"options": ["Industria alimentară", "Industria energetică", "Industria chimică", "Industria lemnului"],
			"correct_index": 1
		},
		{
			"id": "c5_q4",
			"type": TYPE_SINGLE,
			"text": "Ce plantă agricolă se cultivă pe suprafețe întinse în Câmpia Română pentru ulei?",
			"options": ["Cartoful", "Floarea-soarelui", "Vița-de-vie", "Sfecla de zahăr"],
			"correct_index": 1
		},
		{
			"id": "c5_q5",
			"type": TYPE_MULTI,
			"text": "Care dintre următoarele sunt plante cultivate?",
			"options": ["Grâul", "Porumbul", "Bradul", "Floarea-soarelui"],
			"correct_indices": [0, 1, 3]
		},
		{
			"id": "c5_q6",
			"type": TYPE_SINGLE,
			"text": "În ce zone de relief se cultivă predominant vița-de-vie și pomii fructiferi?",
			"options": ["În zonele de munte", "În zonele de deal și podiș", "În Delta Dunării", "În luncile râurilor"],
			"correct_index": 1
		},
		{
			"id": "c5_q7",
			"type": TYPE_SINGLE,
			"text": "Care este cel mai ieftin tip de transport pentru mărfurile voluminoase?",
			"options": ["Rutier", "Aerian", "Feroviar", "Naval"],
			"correct_index": 3
		},
		{
			"id": "c5_q8",
			"type": TYPE_MULTI,
			"text": "Ce tipuri de centrale produc energie electrică în România?",
			"options": ["Hidrocentrale", "Termocentrale", "Eoliene", "Solare"],
			"correct_indices": [0, 1, 2, 3]
		},
		{
			"id": "c5_q9",
			"type": TYPE_TEXT,
			"text": "Resursa naturală lichidă din care se face benzină este ______.",
			"correct_answer": "Petrolul"
		},
		{
			"id": "c5_q10",
			"type": TYPE_SINGLE,
			"text": "Ce tip de transport folosește 'magistralele' care pornesc din București?",
			"options": ["Aerian", "Feroviar", "Maritim", "Conducte"],
			"correct_index": 1
		},
		{
			"id": "c5_q11",
			"type": TYPE_SINGLE,
			"text": "Ce tip de centrală electrică folosește forța apei?",
			"options": ["Termocentrală", "Hidrocentrală", "Eoliană", "Nucleară"],
			"correct_index": 1
		},
		{
			"id": "c5_q12",
			"type": TYPE_MULTI,
			"text": "Care sunt activități industriale?",
			"options": ["Construcția de mașini", "Prelucrarea lemnului", "Creșterea oilor", "Producerea alimentelor"],
			"correct_indices": [0, 1, 3]
		},
		{
			"id": "c5_q13",
			"type": TYPE_SINGLE,
			"text": "Ce oraș este principalul port maritim al României?",
			"options": ["Tulcea", "Giurgiu", "Constanța", "Brăila"],
			"correct_index": 2
		},
		{
			"id": "c5_q14",
			"type": TYPE_MULTI,
			"text": "Care dintre următoarele orașe sunt porturi la Dunăre?",
			"options": ["Galați", "Brașov", "Brăila", "Drobeta-Turnu Severin"],
			"correct_indices": [0, 2, 3]
		}
	],
	
	6: [ # Capitolul 6: Recapitulare (10 întrebări - Mix din capitolele anterioare)
		{
			"id": "c6_q1",
			"type": TYPE_SINGLE,
			"text": "Ce formă de relief predomină în centrul țării?",
			"options": ["Câmpia", "Munții", "Delta", "Podișul"],
			"correct_index": 1
		},
		{
			"id": "c6_q2",
			"type": TYPE_MULTI,
			"text": "Ce categorii de resurse există?",
			"options": ["Resurse de sol", "Resurse de subsol", "Resurse de suprafață", "Resurse spațiale"],
			"correct_indices": [0, 1, 2]
		},
		{
			"id": "c6_q3",
			"type": TYPE_TEXT,
			"text": "Animalul crescut în special la munte pentru lână și lapte este ______.",
			"correct_answer": "Oaia"
		},
		{
			"id": "c6_q4",
			"type": TYPE_SINGLE,
			"text": "Aeroportul principal al României (Henri Coandă) se află lângă orașul:",
			"options": ["Cluj-Napoca", "Timișoara", "București", "Iași"],
			"correct_index": 2
		},
		{
			"id": "c6_q5",
			"type": TYPE_MULTI,
			"text": "Ce caracteristici are Marea Neagră?",
			"options": ["Este o mare deschisă", "Are maree mici", "Este o mare continentală", "Apa este dulce"],
			"correct_indices": [1, 2]
		},
		{
			"id": "c6_q6",
			"type": TYPE_TEXT,
			"text": "Sarea este o resursă de ______.",
			"correct_answer": "Subsol"
		},
		{
			"id": "c6_q7",
			"type": TYPE_SINGLE,
			"text": "Brațul Dunării situat la mijloc se numește:",
			"options": ["Chilia", "Sulina", "Sfântul Gheorghe", "Borcea"],
			"correct_index": 1
		},
		{
			"id": "c6_q8",
			"type": TYPE_MULTI,
			"text": "Care dintre următoarele sunt căi de comunicație?",
			"options": ["Rutiere", "Feroviare", "Navale", "De irigații"],
			"correct_indices": [0, 1, 2]
		},
		{
			"id": "c6_q9",
			"type": TYPE_SINGLE,
			"text": "Unde se varsă râul Siret?",
			"options": ["În Mureș", "În Olt", "În Dunăre", "În Marea Neagră"],
			"correct_index": 2
		},
		{
			"id": "c6_q10",
			"type": TYPE_TEXT,
			"text": "Înainte de a se vărsa în Marea Neagră, Dunărea formează o ______.",
			"correct_answer": "Deltă"
		}
	],
	
	7: [ # Capitolul 7: Județul Cluj (Orizontul Local)
		{
			"id": "c7_q1",
			"type": TYPE_SINGLE,
			"text": "Râul care traversează municipiul Cluj-Napoca este:",
			"options": ["Someșul Mare", "Someșul Mic", "Arieș", "Mureș"],
			"correct_index": 1
		},
		{
			"id": "c7_q2",
			"type": TYPE_MULTI,
			"text": "Cu ce județe se învecinează județul Cluj?",
			"options": ["Bihor", "Constanța", "Alba", "Suceava"],
			"correct_indices": [0, 2]
		},
		{
			"id": "c7_q3",
			"type": TYPE_SINGLE,
			"text": "O importantă atracție turistică subterană din județul Cluj este:",
			"options": ["Peștera Urșilor", "Salina Turda", "Vulcanul Noroios", "Sfinxul"],
			"correct_index": 1
		},
		{
			"id": "c7_q4",
			"type": TYPE_TEXT,
			"text": "Cetatea istorică situată pe un deal din Cluj-Napoca se numește ______.",
			"correct_answer": "Cetățuia"
		},
		{
			"id": "c7_q5",
			"type": TYPE_SINGLE,
			"text": "Statuia din Piața Unirii îl reprezintă pe regele:",
			"options": ["Decebal", "Mihai Viteazul", "Matia Corvin", "Ștefan cel Mare"],
			"correct_index": 2
		},
		{
			"id": "c7_q6",
			"type": TYPE_MULTI,
			"text": "Ce forme de relief predomină în județul Cluj?",
			"options": ["Marea Neagră", "Dealurile și Podișurile", "Munții Apuseni", "Delta Dunării"],
			"correct_indices": [1, 2]
		},
		{
			"id": "c7_q7",
			"type": TYPE_SINGLE,
			"text": "Grădina Botanică din Cluj-Napoca poartă numele profesorului:",
			"options": ["Alexandru Borza", "Emil Racoviță", "Ana Aslan", "Henri Coandă"],
			"correct_index": 0
		},
		{
			"id": "c7_q8",
			"type": TYPE_TEXT,
			"text": "Municipiul de reședință al județului nostru este ______.",
			"correct_answer": "Cluj-Napoca"
		},
		{
			"id": "c7_q9",
			"type": TYPE_SINGLE,
			"text": "Aeroportul Internațional din Cluj se numește:",
			"options": ["Traian Vuia", "Aurel Vlaicu", "Avram Iancu", "Henri Coandă"],
			"correct_index": 2
		},
		{
			"id": "c7_q10",
			"type": TYPE_MULTI,
			"text": "Selectează orașele care se află în județul Cluj:",
			"options": ["Turda", "Dej", "Sibiu", "Oradea"],
			"correct_indices": [0, 1]
		}
	]
}

# Numele capitolelor pentru afișare UI
var chapter_titles = {
	1: "1. Limite și vecini",
	2: "2. Relieful",
	3: "3. Clima, apele, vegetația",
	4: "4. Locuitorii și așezările",
	5: "5. Activități economice",
	6: "6. Recapitulare",
	7: "7. Județul Cluj"
}
