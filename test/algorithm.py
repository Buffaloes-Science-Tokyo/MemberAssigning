
import random
import json
import polars as pl
import polars.selectors as cs
import math

pl.Config.set_tbl_rows(-1)
pl.Config.set_tbl_cols(-1)

class Person:

    # pos = 0 ~ 10
    def __init__(self, name : str, pos_list : list[int] = [], status : bool = True):
        self.name : str = name
        self.pos : set[int] = set(pos_list)
        self.status : bool = status

    def pos_register(self, pos_list : list[int]):
        for pos in pos_list:
            self.pos.add(pos)

    def renew_status(self,status : bool):
        self.status = status

    def print_profile(self):
        print(f"{self.name}: {"IN" if self.status else "OUT"}, {self.pos}")

RANDOM_NAMES = [
    "Adam","Brian","Chris","Derek","Ethan","Felix","George","Henry","Ian","Jack","Kevin",
    "Liam","Mason","Nathan","Oscar","Paul","Quinn","Ryan","Steve",
    "Trevor","Victor","Wyatt","Xavier",
    "Aaron","Alan","Albert","Alex","Andrew","Anthony","Arthur","Austin","Barry","Ben",
    "Benjamin","Blake","Bradley","Brandon","Brett","Bruce","Bryan","Caleb","Carl","Carter",
    "Charles","Christian","Clark","Cody","Cole","Colin","Connor","Daniel","David","Dennis",
    "Dominic","Douglas","Dylan","Edward","Eli","Elliot","Eric","Evan","Francis","Frank",
    "Gabriel","Gary","Gavin","Gerald","Gordon","Grant","Gregory","Harold","Harrison","Harvey",
    "Hugh","Hunter","Isaac","Jacob","James","Jason","Jeffrey","Jeremy","Jerome","Joel",
    "John","Jonathan","Jordan","Joseph","Joshua","Julian","Justin","Keith","Kyle","Lance",
    "Landon","Lawrence","Leo","Leon"
]

def get_random_persons(count : int, sample : int) -> dict[str,Person]:
    persons = {}
    for i in range(count):
        name = RANDOM_NAMES[i] if i < len(RANDOM_NAMES) else f"Player{i + 1}"
        positions = random.sample(list(range(11)), k=random.randint(1, sample))
        persons[name] = Person(name, positions)
    return persons

def get_available_list(persons : dict[str,Person]) -> list[int,set[str]]:
    available_list = [set([]) for i in range(11)]
    for person in persons.values():
        for pos in person.pos:
            available_list[pos].add(person.name)
    return available_list

def print_availabe_dict(available_list : list[set[str]]):
    print("#==============================================")
    for i, available_persons in enumerate(available_list):
        print(f"{i}:({len(available_persons)}) {available_persons}")
    print("#==============================================")

def save(persons : dict[str,Person], fixed_members : list[str]):
    output = {
        "Persons" : {},
        "fix" : fixed_members,
    }
    for name, person in persons.items():
        output["Persons"][name] = {
            "status" : person.status,
            "pos" : list(person.pos)
        }
    with open("data.json", "w", encoding="utf-8") as f:
        json.dump(
            output,
            f,
            indent=2
        )

def load():
    with open("data.json", "r", encoding="utf-8") as f:
        data = json.load(f)
    input_data = {
        "Persons" : {},
        "fix" : data["fix"],
    }
    for name,person in data["Persons"].items():
        # person : {status : bool, pos : list[int]}
        input_data["Persons"][name] = Person(name,person["pos"],person["status"])
    return input_data


def get_candidate_members(persons : dict[str,Person], available_list : list[set[str]], fixed_list : list[str] = [""]*11) -> pl.DataFrame:
    current_lineup = fixed_list
    assigned : set[str] = set([])
    unassigned : set[int] = set([])
    if fixed_list == [""] * 11:
        unassigned = set(list(range(11)))
    else:
        for i in range(11):
            if fixed_list[i] == "":
                unassigned.add(i) # 既に選んでいるメンバー
            else:
                assigned.add(fixed_list[i]) # 未選択のポジション

    def get_expected_process_time(unassigned : set[int]) -> float:
        cnt = 1    
        for i in unassigned:
            if available_list[i]:
                cnt *= len(available_list[i])
        return math.pow(10,int(math.log10(cnt) - 7)) # おおよその処理時間を与える

    print(get_expected_process_time(unassigned))

    candidate_members = [] # 考えられるメンバーの組

    def DFS(current_lineup : list[str], assigned : set[str], unassigned : set[int]):
        while unassigned:
            i = next(iter(unassigned)) # 未選択のポジションを1つ選ぶ(全部で回すと同じ組み合わせが順番違いで重複生成される)
            if len(available_list[i]) > 0:
                break
            else:
                unassigned.remove(i)
        if len(unassigned) == 0:
            candidate_members.append(current_lineup)
            return
        rest_unassigned = unassigned - {i}
        for possible_member in available_list[i]: # そのポジションに携われるメンバー
            if not possible_member in assigned and persons[possible_member].status: # すでに選ばれているメンバーでない＋インできるから選択できる
                next_lineup = current_lineup.copy()
                next_lineup[i] = possible_member
                DFS(next_lineup, assigned | {possible_member}, rest_unassigned)

    DFS(current_lineup,assigned,unassigned)
    
    return pl.DataFrame(
        data=candidate_members,
        schema=list(map(str,range(11))),
        orient="row"
    )



Persons : dict[str,Person] = {}
availabe_list : list[set(str)] = []
fixed_members : list[str] = []
candidate_members : pl.DataFrame = []

while True:
    order = input(
        "a : available dict, status : print status of fixed members, r : renew status, g : get candidate members, s : save, l : load, e : exit\n"
        )

    if order == "a":
        print("Available")
        print_availabe_dict(availabe_list)
    elif order == "r":
        while True:
            name = input("who is renewed?\n")
            if name in Persons:
                break
            else:
                print("No such person here")
        Persons[name].print_profile()
        while True:
            new_status = input("t:True,f:False\n")
            if new_status in set(["t","f"]):
                break
            else:
                print("Wrong input")
        Persons[name].renew_status(True if new_status == "t" else False)
        Persons[name].print_profile()
    elif order == "status":
        print(f"fixed_members:{fixed_members}")
        print(f"Status-True:{[name if name != "" and Persons[name].status else "X" for name in fixed_members]}")
    elif order == "fix":
        print("Enter fixed members")
        chosed_members : set[str] = set([])
        for i in range(11):
            is_chosed = False
            while True:
                name = input(f"Who is in {i}?\n")
                if name in availabe_list[i] and not name in chosed_members:
                    is_chosed = True
                    break
                elif name == "":
                    break
                else:
                    print("try agin.")
            if is_chosed:
                fixed_members[i] = name
        print("member chosen")
        print(fixed_members)
    elif order == "g":
        candidate_members = get_candidate_members(persons=Persons,available_list=availabe_list,fixed_list=fixed_members)
        print(candidate_members)
    elif order == "s":
        save(persons=Persons,fixed_members=fixed_members)
    elif order == "l":
        input_data = load()
        Persons = input_data["Persons"]
        fixed_members = input_data["fix"]
        availabe_list = get_available_list(persons=Persons)
    elif order == "e":
        break
    else:
        print("unsupported order!")
        continue



