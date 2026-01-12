let courseToPrereqs = {};
let currentMajor = null;
let courseDataMap = {};

function fetchAndBuildTimeline(major) {
   // track the currently selected major so buildTimeline can mark major-required classes
   currentMajor = major;
   let filename = "cse.json";
   if (major === "cis") filename = "cis.json";
   else if (major === "mecheng") filename = "mecheng.json";
   else if (major === "ece-ce") filename = "ece-ce.json";

   fetch(`data/${filename}`)
      .then(response => response.json())
      .then(data => {
         // store a map of courses for the flowchart feature (include semester info)
         courseDataMap = {};
         data.semesters.forEach((semester, sIndex) => {
            semester.courses.forEach(c => {
               courseDataMap[c.id] = {
                  id: c.id,
                  title: c.title,
                  prereqs: Array.isArray(c.prereqs) ? c.prereqs.slice() : [],
                  semesterIndex: sIndex,
                  semesterName: semester.name
               };
            });
         });

         buildTimeline(data);
         // initialize flowchart controls once data is loaded
         initFlowchartControls();
      })
      .catch(error => {
         console.error("Error fetching JSON data:", error);
      });
}

function buildTimeline(data) {
   courseToPrereqs = {};

   const timelineContainer = document.getElementById("timeline-container");

   if (!timelineContainer) {
      console.warn("No #timeline-container element found in DOM");
      return;
   }

   timelineContainer.innerHTML = "";

   data.semesters.forEach(semester => {
      const semesterColumn = document.createElement("div");
      semesterColumn.className = "semester-column";

      const semesterTitle = document.createElement("h3");
      semesterTitle.textContent = semester.name;
      semesterColumn.appendChild(semesterTitle);

      semester.courses.forEach(course => {
         const courseBox = document.createElement("div");
         courseBox.className = "course-box";
         courseBox.id = course.id;
         courseBox.textContent = `${course.title}`;

         // Mark General Education (GE) courses so they can be styled separately.
         // We consider IDs starting with "GE" or titles containing "GE-" or "General Education" as GEs.
         const isGE = (typeof course.id === 'string' && course.id.startsWith('GE')) ||
            (typeof course.title === 'string' && (course.title.includes('GE-') || course.title.toLowerCase().includes('general education')));
         if (isGE) {
            courseBox.classList.add('ge-course');
         }

         // Also treat explicit foreign language courses as GEs (green)
         // Detect by IDs starting with 'FOREIGN_LANG' or titles containing 'Foreign Language'.
         const isForeignLang = (typeof course.id === 'string' && course.id.startsWith('FOREIGN_LANG')) ||
            (typeof course.title === 'string' && /foreign language/i.test(course.title));
         if (isForeignLang) {
            courseBox.classList.add('ge-course');
         }

         // Mark Math courses so they can be styled (blue) and included in the legend.
         // Detect by IDs starting with 'MATH' or titles containing the word 'Math' (case-insensitive).
         const isMath = (typeof course.id === 'string' && course.id.startsWith('MATH')) ||
            (typeof course.title === 'string' && /\bmath\b/i.test(course.title));
         if (isMath) {
            courseBox.classList.add('math-course');
         }

         // Major-specific required courses (red):
         // - For CIS and CSE majors, mark all CSE courses as required.
         // - For ME (mecheng) major, mark all MECHENG courses as required.
         // - For ECE-CE major, Mark all ECE and CSE courses as required.
         const isRequiredForMajor = (
            (currentMajor === 'cis' || currentMajor === 'cse') && (typeof course.id === 'string' && course.id.startsWith('CSE'))
         ) || (
               (currentMajor === 'mecheng') && (typeof course.id === 'string' && course.id.startsWith('MECHENG'))
            ) || (
               (currentMajor === 'ece-ce') && (typeof course.id === 'string' && (course.id.startsWith('ECE') || course.id.startsWith('CSE')))
            );
         if (isRequiredForMajor) {
            courseBox.classList.add('required-course');
         }

         // Mark hard science courses (grey): physics, chemistry, biology, etc.
         // Detect by ID prefixes like 'PHYSICS', 'CHEM', 'BIO' or titles containing keywords.
         const isScience = (typeof course.id === 'string' && (
            course.id.startsWith('PHYSICS') || course.id.startsWith('CHEM') || course.id.startsWith('BIO')
         )) || (typeof course.title === 'string' && /\b(physics|chem|chemistry|biology|bio)\b/i.test(course.title));
         if (isScience) {
            courseBox.classList.add('science-course');
         }

         // Non-core required courses (purple): ISE, STAT, ASC, MATSCEN
         // NOTE: ECE is intentionally NOT listed here so ECE courses can be treated as core for the ECE major.
         const nonCorePrefixes = ['ISE', 'STAT', 'ASC', 'MATSCEN'];
         const isNonCore = (typeof course.id === 'string' && nonCorePrefixes.some(p => course.id.startsWith(p))) ||
            (typeof course.title === 'string' && /\b(ISE|STAT|ASC|MATSCEN)\b/i.test(course.title));
         if (isNonCore) {
            courseBox.classList.add('noncore-required');
         }

         // Tech elective (gold): detect common patterns for tech/technical electives
         // We treat IDs that include 'TECH', explicit tech elective text, or ENGR_ELECTIVE_* as tech electives.
         const isTechElective = (typeof course.id === 'string' && (/TECH/i.test(course.id) || /^ENGR_ELECTIVE_/i.test(course.id))) ||
            (typeof course.title === 'string' && /tech\s+elective|technical\s+elective|tech elective|ENGR-?Elective/i.test(course.title));
         if (isTechElective) {
            courseBox.classList.add('tech-elective');
         }

         // For ECE major, mark ENGR_* (non-electives) as non-core required (purple).
         // Keep ENGR_ELECTIVE_* as tech-elective (gold).
         if (currentMajor === 'ece-ce' && typeof course.id === 'string' && course.id.startsWith('ENGR_') && !/^ENGR_ELECTIVE_/i.test(course.id)) {
            courseBox.classList.add('noncore-required');
         }

         const prereqs = Array.isArray(course.prereqs) ? course.prereqs : [];
         courseToPrereqs[course.id] = [];
         prereqs.forEach(courseId => {
            courseToPrereqs[course.id].push(String(courseId).trim());
         });

         courseBox.addEventListener("mouseenter", () => {
            highlightPrereqs(course.id);
         });
         courseBox.addEventListener("mouseleave", () => {
            removeHighlight(course.id);
         });

         courseBox.addEventListener("click", () => {
            showCourseDetails(course.id);
         });

         semesterColumn.appendChild(courseBox);
      });

      timelineContainer.appendChild(semesterColumn);
   });
}

/* Flowchart functionality */
function initFlowchartControls() {
   const typeSelect = document.getElementById('type-select');
   const courseSelect = document.getElementById('course-select');
   const connectorsToggle = document.getElementById('connectors-toggle');

   if (!typeSelect || !courseSelect) return;

   // populate course select with all courses initially
   populateCourseSelect('all');

   typeSelect.addEventListener('change', () => {
      populateCourseSelect(typeSelect.value);
      clearFlowchart();
   });

   courseSelect.addEventListener('change', () => {
      const courseId = courseSelect.value;
      if (courseId) renderFlowchartForCourse(courseId);
      else clearFlowchart();
   });

   if (connectorsToggle) {
      connectorsToggle.addEventListener('change', () => {
         const svg = document.getElementById('flowchart-svg');
         if (svg) svg.style.display = connectorsToggle.checked ? 'block' : 'none';
      });
      // set initial state
      const svg = document.getElementById('flowchart-svg');
      if (svg) svg.style.display = connectorsToggle.checked ? 'block' : 'none';
   }
}

function populateCourseSelect(type) {
   const courseSelect = document.getElementById('course-select');
   if (!courseSelect) return;
   courseSelect.innerHTML = '<option value="">(choose course)</option>';

   const entries = Object.values(courseDataMap).filter(c => {
      if (type === 'all') return true;
      if (type === 'ge') return !!(c.id && c.id.startsWith('GE')) || /ge-|general education/i.test(c.title);
      if (type === 'math') return !!(c.id && c.id.startsWith('MATH')) || /\bmath\b/i.test(c.title);
      if (type === 'core') return !!(c.id && (c.id.startsWith('CSE') || c.id.startsWith('MECHENG') || c.id.startsWith('ECE')));
      if (type === 'noncore') {
         if (/\b(ISE|STAT|ASC|MATSCEN)\b/i.test(c.id || c.title)) return true;
         // If the currently loaded major is ECE-CE, include ENGR non-electives as non-core
         if (currentMajor === 'ece-ce' && c.id && /^ENGR_/i.test(c.id) && !/^ENGR_ELECTIVE_/i.test(c.id)) return true;
         return false;
      }
      if (type === 'science') return /\b(PHYSICS|CHEM|BIO)\b/i.test(c.id || c.title) || /physics|chem|biology|bio/i.test(c.title);
      if (type === 'tech') return /TECH/i.test(c.id) || /^ENGR_ELECTIVE_/i.test(c.id) || /tech\s+elective|technical\s+elective|ENGR-?Elective/i.test(c.title);
      return true;
   });

   // sort alphabetically by title
   entries.sort((a, b) => a.title.localeCompare(b.title));
   for (const c of entries) {
      const opt = document.createElement('option');
      opt.value = c.id;
      // show only the course title (e.g., 'Math 1151') rather than 'MATH_1151 — Math 1151'
      opt.textContent = c.title;
      courseSelect.appendChild(opt);
   }
}

function clearFlowchart() {
   const cols = document.getElementById('flowchart-columns');
   const svg = document.getElementById('flowchart-svg');
   if (cols) cols.innerHTML = '';
   if (svg) svg.innerHTML = '';
}

function renderFlowchartForCourse(courseId) {
   // collect nodes and edges backward from selected course
   const nodes = new Set();
   const edges = [];

   function dfs(id) {
      if (!id || nodes.has(id) || !courseDataMap[id]) return;
      nodes.add(id);
      const prereqs = courseDataMap[id].prereqs || [];
      for (const p of prereqs) {
         edges.push({ from: p, to: id });
         dfs(p);
      }
   }

   dfs(courseId);

   // compute levels (distance from roots): root nodes have level 0
   const levels = {};
   function computeLevel(id) {
      if (!nodes.has(id)) return 0;
      if (!courseDataMap[id] || !courseDataMap[id].prereqs || courseDataMap[id].prereqs.length === 0) return 0;
      if (levels[id] !== undefined) return levels[id];
      const prereqs = courseDataMap[id].prereqs.filter(p => nodes.has(p));
      if (prereqs.length === 0) { levels[id] = 0; return 0; }
      const lv = 1 + Math.max(...prereqs.map(p => computeLevel(p)));
      levels[id] = lv;
      return lv;
   }

   computeLevel(courseId);

   // group nodes by level
   const grouped = {};
   for (const id of nodes) {
      const lv = levels[id] !== undefined ? levels[id] : computeLevel(id);
      grouped[lv] = grouped[lv] || [];
      grouped[lv].push(id);
   }

   const maxLevel = Math.max(...Object.keys(grouped).map(Number));

   // render columns left-to-right from level 0 to maxLevel
   const cols = document.getElementById('flowchart-columns');
   const svg = document.getElementById('flowchart-svg');
   if (!cols || !svg) return;
   cols.innerHTML = '';
   svg.innerHTML = '';

   for (let lv = 0; lv <= maxLevel; lv++) {
      const col = document.createElement('div');
      col.className = 'flow-column';
      const ids = grouped[lv] || [];
      // sort by semester index so same-semester courses stack together, then by title
      ids.sort((a, b) => {
         const aIdx = (courseDataMap[a] && courseDataMap[a].semesterIndex) || 0;
         const bIdx = (courseDataMap[b] && courseDataMap[b].semesterIndex) || 0;
         if (aIdx !== bIdx) return aIdx - bIdx;
         const aTitle = (courseDataMap[a] && courseDataMap[a].title) || a;
         const bTitle = (courseDataMap[b] && courseDataMap[b].title) || b;
         return aTitle.localeCompare(bTitle);
      });
      for (const id of ids) {
         const box = document.createElement('div');
         box.className = 'flow-box';
         box.dataset.courseId = id;
         box.id = `flowbox-${id}`;
         const title = courseDataMap[id] ? courseDataMap[id].title : id;
         // show only the human-readable title in the flowchart box
         box.textContent = title;
         // add color classes based on earlier detection
         if ((id && id.startsWith('GE')) || /ge-|general education/i.test(title)) box.classList.add('ge-course');
         if (id && id.startsWith('MATH')) box.classList.add('math-course');
         if (id && (id.startsWith('CSE') || id.startsWith('MECHENG') || id.startsWith('ECE'))) box.classList.add('required-course');
         if (/\b(ISE|STAT|ASC|MATSCEN)\b/i.test(id || title)) box.classList.add('noncore-required');
         if (/\b(PHYSICS|CHEM|BIO)\b/i.test(id || title) || /physics|chem|biology|bio/i.test(title)) box.classList.add('science-course');
         if (/TECH/i.test(id) || /^ENGR_ELECTIVE_/i.test(id) || /tech\s+elective|technical\s+elective|ENGR-?Elective/i.test(title)) box.classList.add('tech-elective');
         // For ECE major, ENGR_* (non-electives) should be purple (noncore)
         if (currentMajor === 'ece-ce' && id && id.startsWith('ENGR_') && !/^ENGR_ELECTIVE_/i.test(id)) box.classList.add('noncore-required');
         // append each box into the column so boxes stack vertically inside the column
         col.appendChild(box);
      }
      // now append the fully-populated column to the columns container
      cols.appendChild(col);
   }

   // small timeout to ensure DOM positioned, then draw edges using SVG lines
   setTimeout(() => {
      const svgRect = svg.getBoundingClientRect();
      svg.setAttribute('width', svgRect.width);
      svg.setAttribute('height', svgRect.height);
      for (const edge of edges) {
         if (!nodes.has(edge.from) || !nodes.has(edge.to)) continue;
         const fromEl = document.getElementById(`flowbox-${edge.from}`);
         const toEl = document.getElementById(`flowbox-${edge.to}`);
         if (!fromEl || !toEl) continue;
         const f = fromEl.getBoundingClientRect();
         const t = toEl.getBoundingClientRect();
         const startX = f.right - svgRect.left;
         const startY = f.top + f.height / 2 - svgRect.top;
         const endX = t.left - svgRect.left;
         const endY = t.top + t.height / 2 - svgRect.top;

         const line = document.createElementNS('http://www.w3.org/2000/svg', 'path');
         const dx = Math.max(20, (endX - startX) / 2);
         const d = `M ${startX} ${startY} C ${startX + dx} ${startY} ${endX - dx} ${endY} ${endX} ${endY}`;
         line.setAttribute('d', d);
         line.setAttribute('fill', 'none');
         line.setAttribute('stroke', '#888');
         line.setAttribute('stroke-width', '1.5');
         svg.appendChild(line);
      }
   }, 50);
}

function showCourseDetails(courseId) {
   const detailsDiv = document.getElementById("details-container");
   detailsDiv.innerHTML = "";

   const closeButton = document.createElement('button');
   closeButton.textContent = 'Close';
   closeButton.className = 'bux-button bux-button--alt-small';
   closeButton.addEventListener('click', () => {
      detailsDiv.classList.remove('visible');
   });
   detailsDiv.appendChild(closeButton);

   const infoDiv = document.createElement('div');

   const courseTitle = document.createElement("h4");
   const courseEl = document.getElementById(courseId);
   const title = (courseEl && courseEl.textContent) ? courseEl.textContent : courseId;
   courseTitle.textContent = title;
   infoDiv.appendChild(courseTitle);

   const prereqHeading = document.createElement('h5');
   prereqHeading.textContent = 'Prerequisites';
   infoDiv.appendChild(prereqHeading);

   const prereqList = document.createElement("ul");
   const prereqs = courseToPrereqs[courseId] || [];
   prereqs.forEach(prereqId => {
      const listItem = document.createElement("li");
      listItem.textContent = prereqId;
      prereqList.appendChild(listItem);
   });
   infoDiv.appendChild(prereqList);
   detailsDiv.appendChild(infoDiv);

   detailsDiv.classList.add('visible');
}

function highlightPrereqs(courseId) {
   const list = courseToPrereqs[courseId] || [];
   for (const cid of list) {
      const prereqBox = document.getElementById(cid);
      if (prereqBox) prereqBox.classList.add("prereq-highlight");
   }
}

function removeHighlight(courseId) {
   const list = courseToPrereqs[courseId] || [];
   for (const cid of list) {
      const prereqBox = document.getElementById(cid);
      if (prereqBox) prereqBox.classList.remove("prereq-highlight");
   }
}

document.addEventListener("DOMContentLoaded", function () {
   const majorDropdown = document.getElementById("major-select");

   majorDropdown.addEventListener("change", function () {
      const selectedMajor = majorDropdown.value;
      fetchAndBuildTimeline(selectedMajor);
   });

   fetchAndBuildTimeline(majorDropdown.value);
});