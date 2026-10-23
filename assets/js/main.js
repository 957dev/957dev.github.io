// Future portfolio rendering starts here. Existing content remains static HTML.
export async function loadProjects() {
  const response = await fetch(new URL('../../data/projects.json', import.meta.url));
  if (!response.ok) throw new Error(`Project data: HTTP ${response.status}`);
  return response.json();
}
